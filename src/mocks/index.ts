import { getSeed } from './data/evaluation';
import portraitData from '../mock/portrait.json';

let installed = false;

function toResponse(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), { status, headers: { 'content-type': 'application/json' } });
}

function parseUrl(input: RequestInfo | URL) {
  const u = typeof input === 'string' ? input : (input as Request).url || String(input);
  try { return new URL(u, typeof window !== 'undefined' ? window.location.origin : 'http://localhost'); } catch { return new URL('http://localhost'); }
}

async function handleEvaluation(input: RequestInfo | URL, init?: RequestInit) {
  const url = parseUrl(input);
  const method = (init?.method || 'GET').toUpperCase();
  const scenario = url.searchParams.get('scenario') || 'ok';

  if (scenario === 'error') {
    return toResponse({ error: 'mock error' }, 500);
  }

  if (method === 'GET') {
    const courseId = url.searchParams.get('course_id');
    const clazzId = url.searchParams.get('clazz_id');
    const studentId = url.searchParams.get('student_id');
    const limit = Math.min(Number(url.searchParams.get('limit') || 50), 200);
    const offset = Number(url.searchParams.get('offset') || 0);

    let rows = getSeed();
    if (courseId) rows = rows.filter(r => r.course_id === Number(courseId));
    if (clazzId) rows = rows.filter(r => (r.clazz_id ?? null) === Number(clazzId));
    if (studentId) rows = rows.filter(r => r.student_id === String(studentId));

    if (scenario === 'empty') rows = [];

    const paged = rows.slice(offset, offset + limit);
    return toResponse(paged, 200);
  }

  if (method === 'POST') {
    if (scenario === 'empty') return toResponse({ id: 0 }, 201);
    const bodyText = typeof init?.body === 'string' ? init?.body : (init?.body ? await new Response(init?.body).text() : '{}');
    const body = JSON.parse(bodyText || '{}');
    if (!body?.course_id || !body?.student_id) return toResponse({ error: 'course_id 和 student_id 为必填' }, 400);
    const list = getSeed();
    const nextId = Math.max(...list.map(i => i.id)) + 1;
    return toResponse({ id: nextId }, 201);
  }

  return toResponse({ error: 'Method Not Allowed' }, 405);
}

export function setupMock() {
  if (installed) return;
  installed = true;
  const originalFetch = typeof window !== 'undefined' ? window.fetch.bind(window) : fetch;
  const patched = async (input: RequestInfo | URL, init?: RequestInit) => {
    const url = parseUrl(input);
    const path = url.pathname;
    if (path.startsWith('/api/evaluation')) return handleEvaluation(input, init);
    if (path.startsWith('/api/items')) {
      const method = (init?.method || 'GET').toUpperCase();
      if (method === 'GET') {
        return toResponse([{ id: 1, name: '示例条目' }], 200);
      }
      if (method === 'POST') {
        return toResponse({ id: 2 }, 201);
      }
      return toResponse({ error: 'Method Not Allowed' }, 405);
    }
    if (path.startsWith('/api/chat/completions')) {
      const encoder = new TextEncoder();
      const stream = new ReadableStream({
        start(controller) {
          const chunks = [
            'data: 明',
            'data: 小',
            'data: 蹊',
            'data: ：',
            'data: 这是模拟的流式回复。',
            'data: \n• 请保持积极心态\n• 制定每日小目标',
            'data: [DONE]'
          ];
          let i = 0;
          const tick = () => {
            if (i >= chunks.length) { controller.close(); return; }
            controller.enqueue(encoder.encode(chunks[i] + "\n\n"));
            i++;
            setTimeout(tick, 150);
          };
          tick();
        }
      });
      return new Response(stream, { status: 200, headers: { 'content-type': 'text/event-stream' } });
    }
    if (path.startsWith('/api/auth/register')) {
      const bodyText = typeof init?.body === 'string' ? init?.body : (init?.body ? await new Response(init?.body).text() : '{}');
      const body = JSON.parse(bodyText || '{}');
      if (!body?.name || !body?.phone || !body?.password) return toResponse({ error: '缺少必填项' }, 400);
      if (String(body?.phone).startsWith('000')) return toResponse({ error: '账号已存在' }, 409);
      return toResponse({ id: Math.floor(Math.random() * 10000) + 100 }, 201);
    }
    if (path.startsWith('/api/portrait/trend')) {
      const subject = url.searchParams.get('subject') || '语文';
      const base = (portraitData as any)[subject]?.stats?.dailyHours ?? 1.5;
      const days = 30;
      const start = new Date(); start.setDate(start.getDate() - (days - 1));
      const list = Array.from({ length: days }, (_, i) => {
        const d = new Date(start); d.setDate(start.getDate() + i);
        const v = base + Math.sin(i / 6) * 0.5 + (Math.random() - 0.5) * 0.3;
        return { date: d.toISOString().slice(0, 10), hours: Number(Math.max(0.2, Number(v.toFixed(2)))) };
      });
      return toResponse({ subject, series: list }, 200);
    }
    if (path.startsWith('/api/portrait/skills-graph')) {
      const subject = url.searchParams.get('subject') || '语文';
      const d = (portraitData as any)[subject] || {};
      const base = [...(d.coreSkills || []), ...(d.appliedSkills || [])];
      const tags = ['基础', '应用', '拓展'];
      const nodes = base.flatMap((n: any) => {
        const children = tags.map(t => ({ name: `${n.name}-${t}`, value: Math.max(40, Math.min(95, n.value + Math.round((Math.random() - 0.5) * 20))) }));
        return [n, ...children];
      });
      const center = subject;
      const edges: any[] = [];
      base.forEach((n: any) => {
        edges.push({ source: center, target: n.name, weight: Math.max(1, Math.floor(n.value / 20)) });
        tags.forEach(t => {
          edges.push({ source: n.name, target: `${n.name}-${t}`, weight: 1 });
        });
      });
      return toResponse({ subject, nodes, edges }, 200);
    }
    if (path.startsWith('/api/portrait/knowledge-graph')) {
      const subject = url.searchParams.get('subject') || '语文';
      const d = (portraitData as any)[subject] || {};
      const base = [...(d.classicKnowledge || []), ...(d.modernKnowledge || [])];
      const tags = ['基础概念', '例题', '易错点'];
      const nodes = base.flatMap((n: any) => {
        const children = tags.map(t => ({ name: `${n.name}-${t}`, value: Math.max(40, Math.min(95, n.value + Math.round((Math.random() - 0.5) * 20))) }));
        return [n, ...children];
      });
      const center = subject;
      const edges: any[] = [];
      base.forEach((n: any) => {
        edges.push({ source: center, target: n.name, weight: Math.max(1, Math.floor(n.value / 20)) });
        tags.forEach(t => {
          edges.push({ source: n.name, target: `${n.name}-${t}`, weight: 1 });
        });
      });
      return toResponse({ subject, nodes, edges }, 200);
    }
    return originalFetch(input as any, init as any);
  };
  if (typeof window !== 'undefined') {
    (window as any).fetch = patched as any;
  }
}
