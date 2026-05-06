"""
=============================================================
KNOWLEDGE BASE - Đọc và phân tích file knowledge.txt
=============================================================
Hỗ trợ 2 định dạng:
  1. Q&A: "Q: câu hỏi\nA: câu trả lời"
  2. Chủ đề: "## Tên chủ đề\nNội dung..."
=============================================================
"""

import re
import os
import logging
from typing import List, Dict, Tuple, Optional

logger = logging.getLogger(__name__)


class KnowledgeBase:
    """
    Lưu trữ và tra cứu kiến thức từ file .txt.
    Không cần GPU, không cần model lớn.
    Sử dụng TF-IDF + keyword matching để tìm kiếm.
    """

    def __init__(self):
        self.topics: Dict[str, str] = {}       # {tên chủ đề: nội dung}
        self.qa_pairs: List[Dict] = []         # [{question, answer, topic, keywords}]
        self.raw_sentences: List[Dict] = []    # tất cả câu để tìm kiếm
        self._is_loaded = False

        # TF-IDF matrices (được tính sau khi load)
        self._tfidf_matrix = None
        self._vectorizer = None

    # ─── Load file ────────────────────────────────────────

    def load_file(self, file_path: str) -> Dict:
        """
        Đọc và phân tích file knowledge.txt
        
        Returns:
            dict thống kê: topics_count, qa_count, sentences_count
        """
        if not os.path.exists(file_path):
            raise FileNotFoundError(f"Không tìm thấy file: {file_path}")

        logger.info(f"📖 Loading knowledge from: {file_path}")

        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        # Reset
        self.topics = {}
        self.qa_pairs = []
        self.raw_sentences = []

        # Parse nội dung
        self._parse_topics(content)
        self._parse_qa_pairs(content)
        self._extract_sentences()
        self._build_search_index()

        self._is_loaded = True

        stats = {
            'topics_count': len(self.topics),
            'qa_count': len(self.qa_pairs),
            'sentences_count': len(self.raw_sentences),
            'file_path': file_path,
            'file_size_kb': round(os.path.getsize(file_path) / 1024, 1)
        }
        logger.info(f"✅ Knowledge loaded: {stats}")
        return stats

    def _parse_topics(self, content: str):
        """Phân tích các chủ đề bắt đầu bằng ## hoặc #"""
        # Tách theo dấu ## (heading level 2)
        topic_pattern = re.compile(
            r'##\s*(.+?)\n(.*?)(?=##|\Z)',
            re.DOTALL
        )
        for match in topic_pattern.finditer(content):
            topic_name = match.group(1).strip()
            topic_content = match.group(2).strip()
            if topic_name and topic_content:
                self.topics[topic_name] = topic_content
                logger.debug(f"  Topic: '{topic_name}' ({len(topic_content)} chars)")

        logger.info(f"  → Parsed {len(self.topics)} topics")

    def _parse_qa_pairs(self, content: str):
        """Phân tích các cặp Q: ... A: ..."""
        # Pattern linh hoạt: Q:, Hỏi:, Khách:
        q_pattern = re.compile(
            r'(?:Q:|Hỏi:|Khách:|[Qq]uestion:)\s*(.+?)(?:\n|$)',
            re.MULTILINE
        )
        a_pattern = re.compile(
            r'(?:A:|Đáp:|Shop:|[Aa]nswer:|Trả lời:)\s*(.+?)(?=\n(?:Q:|Hỏi:|Khách:|A:|Đáp:|Shop:|##|-----)|$)',
            re.DOTALL
        )

        lines = content.split('\n')
        current_q = None
        current_a_lines = []
        current_topic = None

        for line in lines:
            line = line.strip()

            # Theo dõi chủ đề hiện tại
            if line.startswith('##'):
                current_topic = line.lstrip('#').strip()

            # Dòng câu hỏi
            q_match = re.match(r'^(?:Q:|Hỏi:|Khách:)\s*(.+)', line)
            if q_match:
                # Lưu cặp Q&A trước (nếu có)
                if current_q and current_a_lines:
                    self._add_qa(current_q, ' '.join(current_a_lines), current_topic)
                current_q = q_match.group(1).strip()
                current_a_lines = []
                continue

            # Dòng câu trả lời
            a_match = re.match(r'^(?:A:|Đáp:|Shop:)\s*(.+)', line)
            if a_match and current_q:
                current_a_lines.append(a_match.group(1).strip())
                continue

            # Tiếp tục câu trả lời dài (nếu đang trong block A)
            if current_a_lines and line and not line.startswith('Q:') \
                    and not line.startswith('Hỏi:') and not line.startswith('##') \
                    and not line.startswith('-----'):
                current_a_lines.append(line)

        # Lưu cặp cuối cùng
        if current_q and current_a_lines:
            self._add_qa(current_q, ' '.join(current_a_lines), current_topic)

        logger.info(f"  → Parsed {len(self.qa_pairs)} Q&A pairs")

    def _add_qa(self, question: str, answer: str, topic: Optional[str] = None):
        """Thêm một cặp Q&A vào danh sách"""
        question = question.strip()
        answer = answer.strip()
        if not question or not answer:
            return

        self.qa_pairs.append({
            'question': question,
            'answer': answer,
            'topic': topic or 'Chung',
            'keywords': self._extract_keywords(question + ' ' + answer)
        })

    def _extract_sentences(self):
        """Trích xuất tất cả câu từ nội dung chủ đề"""
        for topic_name, content in self.topics.items():
            # Tách câu
            sentences = re.split(r'[.!?]\s+|\n+', content)
            for sent in sentences:
                sent = sent.strip()
                if len(sent) > 20:  # Bỏ câu quá ngắn
                    self.raw_sentences.append({
                        'text': sent,
                        'topic': topic_name,
                        'keywords': self._extract_keywords(sent)
                    })

    def _extract_keywords(self, text: str) -> List[str]:
        """Trích xuất từ khóa từ text tiếng Việt"""
        # Làm sạch
        text = text.lower()
        text = re.sub(r'[^\w\s]', ' ', text)

        # Stopwords tiếng Việt cơ bản
        stopwords = {
            'và', 'hoặc', 'là', 'có', 'không', 'của', 'cho', 'với',
            'trong', 'ngoài', 'trên', 'dưới', 'này', 'đó', 'khi',
            'thì', 'mà', 'nhưng', 'vì', 'để', 'từ', 'đến', 'bởi',
            'tại', 'hay', 'cũng', 'đều', 'rất', 'khá', 'hơn', 'nhất',
            'được', 'bị', 'làm', 'như', 'theo', 'về', 'ra', 'vào',
            'lên', 'xuống', 'qua', 'lại', 'đã', 'sẽ', 'đang', 'cần',
            'muốn', 'biết', 'thấy', 'nên', 'phải', 'có thể', 'bạn',
            'shop', 'ạ', 'ơi', 'nhé', 'nha', 'ah', 'uh', 'thôi',
            'mình', 'em', 'anh', 'chị', 'bạn', 'ạ'
        }

        words = text.split()
        keywords = [w for w in words if len(w) > 2 and w not in stopwords]
        return list(set(keywords))

    def _build_search_index(self):
        """Xây dựng TF-IDF index để tìm kiếm nhanh"""
        try:
            from sklearn.feature_extraction.text import TfidfVectorizer
            import numpy as np

            # Gộp tất cả texts: câu hỏi từ Q&A + câu từ topics
            all_texts = []
            for qa in self.qa_pairs:
                all_texts.append(qa['question'])
            for sent in self.raw_sentences:
                all_texts.append(sent['text'])

            if len(all_texts) < 2:
                return

            self._vectorizer = TfidfVectorizer(
                analyzer='char_wb',   # Character n-gram, tốt cho tiếng Việt
                ngram_range=(2, 4),
                min_df=1,
                max_features=5000,
                sublinear_tf=True
            )

            self._tfidf_matrix = self._vectorizer.fit_transform(all_texts)
            logger.info(f"  → TF-IDF index built: {self._tfidf_matrix.shape}")

        except ImportError:
            logger.warning("  ⚠️  sklearn not installed. Using keyword matching only.")

    # ─── Tìm kiếm ─────────────────────────────────────────

    def search(self, query: str, top_k: int = 3, threshold: float = 0.3) -> List[Dict]:
        """
        Tìm kiếm câu trả lời phù hợp nhất cho câu hỏi.
        
        Args:
            query: câu hỏi của người dùng
            top_k: số kết quả trả về
            threshold: ngưỡng độ tương đồng tối thiểu
        
        Returns:
            List[Dict]: [{answer, source, confidence, topic}, ...]
        """
        results = []

        # 1. Tìm kiếm exact/fuzzy trong Q&A pairs
        qa_results = self._search_qa_pairs(query, top_k)
        results.extend(qa_results)

        # 2. TF-IDF search (nếu có)
        if self._vectorizer is not None and self._tfidf_matrix is not None:
            tfidf_results = self._search_tfidf(query, top_k)
            results.extend(tfidf_results)

        # 3. Keyword fallback
        if not results:
            kw_results = self._search_keywords(query, top_k)
            results.extend(kw_results)

        # Lọc theo threshold và deduplicate
        results = [r for r in results if r['confidence'] >= threshold]
        results = self._deduplicate(results)
        results.sort(key=lambda x: x['confidence'], reverse=True)

        return results[:top_k]

    def _search_qa_pairs(self, query: str, top_k: int) -> List[Dict]:
        """Tìm trong danh sách Q&A pairs"""
        results = []
        query_lower = query.lower()
        query_keywords = self._extract_keywords(query)

        for qa in self.qa_pairs:
            score = 0.0
            q_lower = qa['question'].lower()

            # 1. Exact match
            if query_lower == q_lower:
                score = 1.0
            # 2. Substring match
            elif query_lower in q_lower or q_lower in query_lower:
                score = 0.8
            # 3. Keyword overlap
            else:
                q_keywords = qa['keywords']
                if q_keywords and query_keywords:
                    overlap = len(set(query_keywords) & set(q_keywords))
                    score = overlap / max(len(query_keywords), len(q_keywords), 1)
                    score = min(score * 1.2, 0.9)  # Boost keyword score

            if score > 0.1:
                results.append({
                    'answer': qa['answer'],
                    'source': 'qa_pair',
                    'confidence': score,
                    'topic': qa.get('topic', 'Chung'),
                    'matched_question': qa['question']
                })

        results.sort(key=lambda x: x['confidence'], reverse=True)
        return results[:top_k]

    def _search_tfidf(self, query: str, top_k: int) -> List[Dict]:
        """Tìm kiếm bằng TF-IDF cosine similarity"""
        try:
            from sklearn.metrics.pairwise import cosine_similarity
            import numpy as np

            query_vec = self._vectorizer.transform([query])
            similarities = cosine_similarity(query_vec, self._tfidf_matrix)[0]

            # Lấy top indices
            top_indices = np.argsort(similarities)[::-1][:top_k * 2]
            n_qa = len(self.qa_pairs)
            results = []

            for idx in top_indices:
                score = float(similarities[idx])
                if score < 0.15:
                    continue

                if idx < n_qa:
                    # Là Q&A pair
                    qa = self.qa_pairs[idx]
                    results.append({
                        'answer': qa['answer'],
                        'source': 'tfidf_qa',
                        'confidence': score,
                        'topic': qa.get('topic', 'Chung'),
                        'matched_question': qa['question']
                    })
                else:
                    # Là câu từ topic
                    sent_idx = idx - n_qa
                    if sent_idx < len(self.raw_sentences):
                        sent = self.raw_sentences[sent_idx]
                        results.append({
                            'answer': sent['text'],
                            'source': 'tfidf_topic',
                            'confidence': score * 0.8,  # Giảm nhẹ vì là câu topic
                            'topic': sent.get('topic', 'Chung')
                        })

            return results

        except Exception as e:
            logger.debug(f"TF-IDF search error: {e}")
            return []

    def _search_keywords(self, query: str, top_k: int) -> List[Dict]:
        """Fallback: tìm kiếm theo từ khóa đơn giản"""
        query_keywords = set(self._extract_keywords(query))
        results = []

        for qa in self.qa_pairs:
            qa_keywords = set(qa['keywords'])
            if query_keywords & qa_keywords:
                score = len(query_keywords & qa_keywords) / max(len(query_keywords), 1)
                results.append({
                    'answer': qa['answer'],
                    'source': 'keyword',
                    'confidence': score * 0.6,
                    'topic': qa.get('topic', 'Chung')
                })

        # Tìm trong topic content
        for sent in self.raw_sentences:
            sent_keywords = set(sent['keywords'])
            if query_keywords & sent_keywords:
                score = len(query_keywords & sent_keywords) / max(len(query_keywords), 1)
                results.append({
                    'answer': sent['text'],
                    'source': 'keyword_topic',
                    'confidence': score * 0.5,
                    'topic': sent.get('topic', 'Chung')
                })

        results.sort(key=lambda x: x['confidence'], reverse=True)
        return results[:top_k]

    def search_topic(self, topic_name: str) -> Optional[str]:
        """Lấy nội dung của một chủ đề"""
        # Tìm exact
        if topic_name in self.topics:
            return self.topics[topic_name]
        # Tìm partial match
        topic_lower = topic_name.lower()
        for name, content in self.topics.items():
            if topic_lower in name.lower() or name.lower() in topic_lower:
                return content
        return None

    def _deduplicate(self, results: List[Dict]) -> List[Dict]:
        """Loại bỏ kết quả trùng lặp"""
        seen = set()
        unique = []
        for r in results:
            # Dùng 50 ký tự đầu làm key
            key = r['answer'][:50].strip().lower()
            if key not in seen:
                seen.add(key)
                unique.append(r)
        return unique

    # ─── Properties ───────────────────────────────────────

    def is_loaded(self) -> bool:
        return self._is_loaded

    def get_topic_names(self) -> List[str]:
        return list(self.topics.keys())

    def get_qa_count(self) -> int:
        return len(self.qa_pairs)
