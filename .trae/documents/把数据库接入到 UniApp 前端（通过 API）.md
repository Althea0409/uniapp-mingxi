## 目标

* 让现有 UniApp 前端安全、稳定地读取/写入现有数据库的数据

* 保持现有代码风格与项目结构，复用前端的 `fetch` 与 `/api` 约定

## 关键原则

* 前端不可直接连接数据库，需通过后端/API

* 数据库凭证只能放在服务端的环境变量中

* 现有 `api/chat/completions.ts` 使用 `runtime: 'edge'`，不适合数据库连接；数据库访问需使用 `runtime: 'nodejs'`

## 架构选项

1. 自建 REST/GraphQL API（推荐）

* 在 `api/` 目录新增 Node 运行时接口，使用 ORM/驱动连接数据库（MySQL: mysql2/Prisma；Postgres: pg/Prisma）

* 暴露 REST 路由如 `GET /api/items`、`POST /api/items`

* 通过环境变量注入数据库连接串

* 前端继续用 `fetch` 调用 `/api/*`，基址由设置页维护

1. 托管 BaaS/网关

* Postgres: Supabase、Hasura、PostgREST

* NoSQL: Firebase、Appwrite

* 前端使用其 SDK 或 HTTP 端点，基址指向 BaaS 提供的 URL

1. uniCloud 路线

* 开通 uniCloud 服务空间并编写云函数访问数据库

* 前端使用 `uniCloud.callFunction` 或 `clientDB`

* 需数据库可被 uniCloud访问或完成迁移

## 推荐实现（REST API + Node 运行时）

### 服务端接口

* 在 `api/` 新增如 `api/items.ts`，声明 `export const config = { runtime: 'nodejs' }`

* 使用数据库驱动连接并实现增删改查

* 使用环境变量 `DB_URL`、`DB_USER`、`DB_PASS`、`DB_NAME`

示例接口（MySQL，Node 运行时）：

```ts
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
```

### 前端调用

* 在设置页将 `Base URL` 设为 `/api`

* 新增前端服务模块如 `src/services/items.ts` 使用 `fetch('/api/items')`

示例前端请求：

```ts
export async function listItems() {
  const res = await fetch('/api/items');
  return res.json();
}
export async function createItem(name: string) {
  const res = await fetch('/api/items', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ name }) });
  return res.json();
}
```

### 本地开发与部署

* 开发阶段：为 H5 开发环境添加 `server.proxy` 以转发 `/api` 到本地/云端接口

* 部署：将 `api/*` 随项目部署到支持 Node 运行时的平台，配置环境变量

* 数据库连接使用 SSL 并限制来源 IP

## 安全与规范

* 统一鉴权（JWT/Session），后端进行权限校验

* 输入校验与防注入（参数校验、预处理语句）

* 分页与排序限制，避免全表扫描

* 错误处理与日志记录，隐藏内部错误细节

## 验证步骤

* 使用 `curl`/接口测试工具验证 `/api/items` 的 GET

