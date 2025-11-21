import type { Evaluation } from '@/services/evaluation';

const seed: Evaluation[] = [
  { id: 1, course_id: 1, clazz_id: 1, student_id: '1', score_content: 90, score_method: 85, score_attitude: 88, score_effect: 87, score_homework: 90, comment: '老师讲课很生动，课堂氛围很好', created_at: '2025-11-20 18:53:44' },
  { id: 2, course_id: 1, clazz_id: 1, student_id: '2', score_content: 75, score_method: 80, score_attitude: 85, score_effect: 78, score_homework: 75, comment: '希望能多讲解一些难点', created_at: '2025-11-20 18:53:44' },
  { id: 3, course_id: 1, clazz_id: 1, student_id: '4', score_content: 92, score_method: 90, score_attitude: 95, score_effect: 93, score_homework: 92, comment: '老师讲解非常清晰，受益匪浅', created_at: '2025-11-20 18:53:44' },
  { id: 4, course_id: 1, clazz_id: 1, student_id: '5', score_content: 78, score_method: 75, score_attitude: 80, score_effect: 77, score_homework: 78, comment: '课程内容不错，但希望能有更多练习', created_at: '2025-11-20 18:53:44' },
  { id: 5, course_id: 1, clazz_id: 1, student_id: '6', score_content: 85, score_method: 82, score_attitude: 88, score_effect: 86, score_homework: 85, comment: '课堂互动很好，学习效果不错', created_at: '2025-11-20 18:53:44' },
  { id: 6, course_id: 1, clazz_id: 2, student_id: '3', score_content: 82, score_method: 85, score_attitude: 88, score_effect: 85, score_homework: 80, comment: '课程内容很丰富，受益匪浅', created_at: '2025-11-20 18:53:44' },
  { id: 7, course_id: 1, clazz_id: 2, student_id: '7', score_content: 70, score_method: 72, score_attitude: 75, score_effect: 73, score_homework: 70, comment: '希望能放慢讲课速度', created_at: '2025-11-20 18:53:44' },
  { id: 8, course_id: 1, clazz_id: 2, student_id: '8', score_content: 83, score_method: 80, score_attitude: 85, score_effect: 82, score_homework: 83, comment: '老师很负责，讲解详细', created_at: '2025-11-20 18:53:44' },
  { id: 9, course_id: 2, clazz_id: 3, student_id: '1', score_content: 88, score_method: 90, score_attitude: 85, score_effect: 87, score_homework: 88, comment: '数学老师讲解清晰，容易理解', created_at: '2025-11-20 18:53:44' },
  { id: 10, course_id: 2, clazz_id: 3, student_id: '9', score_content: 85, score_method: 82, score_attitude: 88, score_effect: 86, score_homework: 85, comment: '数学课程很有趣，逻辑清晰', created_at: '2025-11-20 18:53:44' },
  { id: 11, course_id: 2, clazz_id: 3, student_id: '10', score_content: 78, score_method: 75, score_attitude: 80, score_effect: 77, score_homework: 78, comment: '需要更多练习来巩固知识', created_at: '2025-11-20 18:53:44' },
  { id: 12, course_id: 2, clazz_id: 3, student_id: '11', score_content: 92, score_method: 90, score_attitude: 95, score_effect: 93, score_homework: 92, comment: '数学老师教学方法很好，容易理解', created_at: '2025-11-20 18:53:44' }
];

export function getSeed() {
  return seed.slice();
}
