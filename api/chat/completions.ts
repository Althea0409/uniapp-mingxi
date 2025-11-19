export const config = { runtime: 'edge' };

const DEFAULT_BASE = 'https://dashscope.aliyuncs.com/compatible-mode/v1';

export default async function handler(req: Request): Promise<Response> {
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'Method Not Allowed' }), { status: 405, headers: { 'Content-Type': 'application/json' } });
  }

  const apiKey = process.env.DASHSCOPE_API_KEY || '';
  if (!apiKey) {
    return new Response(JSON.stringify({ error: 'Server not configured: missing DASHSCOPE_API_KEY' }), { status: 500, headers: { 'Content-Type': 'application/json' } });
  }

  let payload: any;
  try {
    payload = await req.json();
  } catch {
    return new Response(JSON.stringify({ error: 'Invalid JSON body' }), { status: 400, headers: { 'Content-Type': 'application/json' } });
  }

  const base = (process.env.DASHSCOPE_BASE_URL || DEFAULT_BASE).replace(/\/$/, '');
  const url = `${base}/chat/completions`;

  const headers = {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${apiKey}`,
  };

  const body = JSON.stringify({
    model: payload?.model || 'qwen-plus',
    messages: payload?.messages || [],
    stream: payload?.stream ?? true,
    stream_options: payload?.stream_options,
    temperature: payload?.temperature,
    top_p: payload?.top_p,
    max_tokens: payload?.max_tokens,
    response_format: payload?.response_format,
  });

  const upstream = await fetch(url, { method: 'POST', headers, body });

  if (!upstream.ok) {
    const text = await upstream.text();
    return new Response(text || JSON.stringify({ error: 'Upstream error' }), { status: upstream.status, headers: { 'Content-Type': 'application/json' } });
  }

  const respHeaders = new Headers(upstream.headers);
  respHeaders.set('Content-Type', 'text/event-stream');
  respHeaders.set('Cache-Control', 'no-cache');
  respHeaders.set('Connection', 'keep-alive');

  return new Response(upstream.body, { status: 200, headers: respHeaders });
}