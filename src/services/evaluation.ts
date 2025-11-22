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

export async function listEvaluations(params: {
  course_id?: number;
  clazz_id?: number;
  student_id?: string;
  limit?: number;
  offset?: number;
  scenario?: 'ok' | 'empty' | 'error';
} = {}): Promise<Evaluation[]> {
  const usp = new URLSearchParams();
  Object.entries(params).forEach(([k, v]) => {
    if (v !== undefined && v !== null) usp.set(k, String(v));
  });
  const res = await fetch(`/api/evaluation${usp.toString() ? `?${usp.toString()}` : ''}`);
  const ct = res.headers.get('content-type') || '';
  const text = await res.text();
  if (!ct.includes('application/json')) return [];
  try {
    const data = JSON.parse(text);
    return Array.isArray(data) ? data as Evaluation[] : [];
  } catch {
    return [];
  }
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
  const res = await fetch('/api/evaluation', {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify(payload),
  });
  const ct = res.headers.get('content-type') || '';
  const text = await res.text();
  if (!ct.includes('application/json')) return { id: 0 };
  try {
    const data = JSON.parse(text);
    const id = typeof (data as any)?.id === 'number' ? (data as any).id : 0;
    return { id };
  } catch {
    return { id: 0 };
  }
}
