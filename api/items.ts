export const config = { runtime: 'nodejs' };
import mysql from 'mysql2/promise';

export default async function handler(req: Request): Promise<Response> {
  const conn = await mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_NAME,
  });

  const url = new URL(req.url);
  if (req.method === 'GET') {
    const [rows] = await conn.execute('SELECT id, name FROM items LIMIT 50');
    await conn.end();
    return new Response(JSON.stringify(rows), { headers: { 'content-type': 'application/json' } });
  }

  if (req.method === 'POST') {
    const body = await req.json();
    await conn.execute('INSERT INTO items(name) VALUES(?)', [body.name]);
    await conn.end();
    return new Response(JSON.stringify({ ok: true }), { headers: { 'content-type': 'application/json' }, status: 201 });
  }

  await conn.end();
  return new Response('Method Not Allowed', { status: 405 });
}

