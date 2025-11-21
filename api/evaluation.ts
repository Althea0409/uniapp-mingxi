export const config = { runtime: 'nodejs' };
import mysql from 'mysql2/promise';

function json(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { 'content-type': 'application/json' },
  });
}

async function getConnection() {
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
  const url = new URL(req.url);
  const method = req.method.toUpperCase();

  if (method === 'GET') {
    const courseId = url.searchParams.get('course_id');
    const clazzId = url.searchParams.get('clazz_id');
    const studentId = url.searchParams.get('student_id');
    const limit = Math.min(Number(url.searchParams.get('limit') || 50), 200);
    const offset = Number(url.searchParams.get('offset') || 0);

    const where: string[] = [];
    const params: any[] = [];
    if (courseId) { where.push('course_id = ?'); params.push(Number(courseId)); }
    if (clazzId) { where.push('clazz_id = ?'); params.push(Number(clazzId)); }
    if (studentId) { where.push('student_id = ?'); params.push(studentId); }

    const sql = `SELECT id, course_id, clazz_id, student_id, score_content, score_method, score_attitude, score_effect, score_homework, comment, created_at
                 FROM evaluation
                 ${where.length ? 'WHERE ' + where.join(' AND ') : ''}
                 ORDER BY id DESC
                 LIMIT ? OFFSET ?`;
    params.push(limit, offset);

    const conn = await getConnection();
    try {
      const [rows] = await conn.execute(sql, params);
      return json(rows);
    } finally {
      await conn.end();
    }
  }

  if (method === 'POST') {
    const body = await req.json();
    const {
      course_id,
      clazz_id,
      student_id,
      score_content,
      score_method,
      score_attitude,
      score_effect,
      score_homework,
      comment,
    } = body || {};

    if (!course_id || !student_id) {
      return json({ error: 'course_id 和 student_id 为必填' }, 400);
    }

    const sql = `INSERT INTO evaluation (course_id, clazz_id, student_id, score_content, score_method, score_attitude, score_effect, score_homework, comment)
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`;
    const params = [
      Number(course_id),
      clazz_id == null ? null : Number(clazz_id),
      String(student_id),
      score_content == null ? null : Number(score_content),
      score_method == null ? null : Number(score_method),
      score_attitude == null ? null : Number(score_attitude),
      score_effect == null ? null : Number(score_effect),
      score_homework == null ? null : Number(score_homework),
      comment == null ? null : String(comment),
    ];

    const conn = await getConnection();
    try {
      const [result]: any = await conn.execute(sql, params);
      return json({ id: result.insertId }, 201);
    } finally {
      await conn.end();
    }
  }

  return json({ error: 'Method Not Allowed' }, 405);
}

