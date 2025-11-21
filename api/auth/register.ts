export const config = { runtime: 'nodejs' };
import mysql from 'mysql2/promise';
import bcrypt from 'bcryptjs';

function json(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), { status, headers: { 'content-type': 'application/json' } });
}

async function getConn() {
  const conn = await mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_NAME,
    multipleStatements: false,
  });
  return conn;
}

export default async function handler(req: Request): Promise<Response> {
  if (req.method !== 'POST') return json({ error: 'Method Not Allowed' }, 405);

  const body = await req.json();
  const name = String(body?.name || '').trim();
  const phone = String(body?.phone || '').trim();
  const password = String(body?.password || '');

  if (!name || !phone || !password) return json({ error: '缺少必填项' }, 400);
  if (password.length < 8 || password.length > 64) return json({ error: '密码长度不合法' }, 400);

  const conn = await getConn();
  try {
    const [exists]: any = await conn.execute('SELECT id FROM users WHERE user_name = ?', [phone]);
    if (Array.isArray(exists) && exists.length) return json({ error: '账号已存在' }, 409);

    const hash = await bcrypt.hash(password, 10);
    const [ret]: any = await conn.execute(
      'INSERT INTO users(user_name, password, real_name, role) VALUES(?, ?, ?, ?)',
      [phone, hash, name, 'STUDENT']
    );
    return json({ id: ret.insertId });
  } finally {
    await conn.end();
  }
}

