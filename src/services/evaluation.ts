export type Evaluation = {
  id: number;
  course_id: number;
  clazz_id: number | null;
  student_id: string;
  score_content: number | null;
  score_method: number | null;
  score_attitude: number | null;
  score_effect: number | null;
  score_homework: number | null;
  comment: string | null;
  created_at: string;
};

import { getSeed } from '@/mocks/data/evaluation';

export async function listEvaluations(params: {
  course_id?: number;
  clazz_id?: number;
  student_id?: string;
  limit?: number;
  offset?: number;
  scenario?: 'ok' | 'empty' | 'error';
} = {}): Promise<Evaluation[]> {
  const { course_id, clazz_id, student_id, limit = 50, offset = 0, scenario = 'ok' } = params || {};
  if (scenario === 'error') return [];
  let rows = getSeed();
  if (course_id) rows = rows.filter(r => r.course_id === course_id);
  if (clazz_id !== undefined && clazz_id !== null) rows = rows.filter(r => (r.clazz_id ?? null) === clazz_id);
  if (student_id) rows = rows.filter(r => r.student_id === String(student_id));
  if (scenario === 'empty') rows = [];
  return rows.slice(offset, offset + Math.min(limit, 200));
}

export async function createEvaluation(payload: {
  course_id: number;
  clazz_id?: number | null;
  student_id: string;
  score_content?: number | null;
  score_method?: number | null;
  score_attitude?: number | null;
  score_effect?: number | null;
  score_homework?: number | null;
  comment?: string | null;
}): Promise<{ id: number }> {
  if (!payload?.course_id || !payload?.student_id) return { id: 0 };
  const list = getSeed();
  const nextId = Math.max(...list.map(i => i.id)) + 1;
  return { id: nextId };
}
