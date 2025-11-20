<template>
  <view class="assistant-page">
    <scroll-view scroll-y class="content" :scroll-into-view="scrollIntoView">
      <Card>
        <view class="assistant-hero">
          <text class="hero-avatar">🤖</text>
          <view class="hero-text">
            <text class="hero-title">我是你的专属学习助手</text>
            <text class="hero-sub">有问题尽管问我吧！</text>
          </view>
        </view>
        <view class="quick-tags">
          <text class="tag" v-for="t in quickTags" :key="t" @tap="sendQuick(t)">{{ t }}</text>
        </view>
      </Card>

      <Card>
        <view class="chat-list">
          <view v-for="(m, i) in messages" :key="i" :class="['msg', m.role]">
            <text class="avatar">{{ m.role === 'user' ? '👤' : '🤖' }}</text>
            <view class="bubble">
              <text v-if="m.role === 'user'" class="text">{{ m.text }}</text>
              <rich-text v-else class="md" :nodes="mdToHtmlAdvanced(m.text)" />
              <view v-if="m.role === 'assistant'" class="feedback">
                <text class="fb" @tap="feedback(true)">👍 有帮助</text>
                <text class="fb" @tap="feedback(false)">👎 没帮助</text>
              </view>
            </view>
          </view>
        </view>
      </Card>
      <view :id="endAnchor" class="chat-spacer"></view>
    </scroll-view>
    <view class="input-fixed">
      <view class="input-bar">
        <input class="input" v-model="input" placeholder="输入你的问题" />
        <view class="actions">
          <text class="icon">📷</text>
          <text class="icon">📁</text>
          <Button :text="sending ? '发送中' : '发送'" :type="sending ? 'secondary' : 'primary'" size="small"
            :disabled="sending" @click="send" />
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, nextTick } from 'vue';
import Card from '@/components/common/Card.vue';
import Button from '@/components/common/Button.vue';
import { useAppStore } from '@/stores/app';
import { streamChat } from '@/services/ai';
import { useUserStore } from '@/stores/user';

const appStore = useAppStore();
const userStore = useUserStore();

const quickTags = ['如何学好高数', '背单词技巧', '作业怎么写', '这道题怎么解'];
const messages = ref<{ role: 'user' | 'assistant'; text: string }[]>([
  { role: 'assistant', text: '你好！我是AI学习助手，有什么可以帮助你？' }
]);
const input = ref('');
const sending = ref(false);
const endAnchor = 'chat-end';
const scrollIntoView = ref(endAnchor);

const sendQuick = (t: string) => {
  input.value = t;
  send();
};

const send = () => {
  if (!input.value) return;
  messages.value.push({ role: 'user', text: input.value });
  const q = input.value;
  input.value = '';
  scrollBottom();
  startStreamReply(q);
};

const feedback = (good: boolean) => {
  appStore.showToast(good ? '已反馈：有帮助' : '已反馈：没帮助', 'success');
  if (good) {
    userStore.addPoints(10);
    appStore.triggerEncouragement('encourage');
  }
};

const startStreamReply = async (q: string) => {
  sending.value = true;
  const idx = messages.value.length;
  messages.value.push({ role: 'assistant', text: '' });
  await scrollBottom();
  try {
    const gen = streamChat([
      { role: 'system', content: '你是友好的学习助手，回答简洁、有条理、分点说明。' },
      { role: 'user', content: q }
    ] as any);
    for await (const chunk of gen) {
      messages.value[idx].text += chunk;
      await scrollBottom();
    }
  } catch (e: any) {
    messages.value[idx].text = '抱歉，AI接口暂不可用，请稍后重试。';
  } finally {
    sending.value = false;
    await scrollBottom();
  }
};

function escapeHtml(str: string) {
  return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

function mdToHtml(md: string): string {
  if (!md) return '';
  let s = md;
  s = s.replace(/```([\s\S]*?)```/g, (_, code) => `<pre class="code"><code>${escapeHtml(code)}</code></pre>`);
  s = s.replace(/^######\s?(.*)$/gm, '<h6>$1</h6>')
    .replace(/^#####\s?(.*)$/gm, '<h5>$1</h5>')
    .replace(/^####\s?(.*)$/gm, '<h4>$1</h4>')
    .replace(/^###\s?(.*)$/gm, '<h3>$1</h3>')
    .replace(/^##\s?(.*)$/gm, '<h2>$1</h2>')
    .replace(/^#\s?(.*)$/gm, '<h1>$1</h1>');
  s = s.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
  s = s.replace(/\*(.*?)\*/g, '<em>$1</em>');
  s = s.replace(/`([^`]+)`/g, '<code>$1</code>');
  const lines = s.split(/\r?\n/);
  let out = '';
  let inUl = false;
  for (const line of lines) {
    const ordered = line.match(/^\s*(\d+)\.\s+(.*)$/);
    if (ordered) {
      const n = ordered[1];
      const content = ordered[2];
      if (inUl) { out += '</ul>'; inUl = false; }
      out += `<ol start="${n}"><li>${content}</li></ol>`;
      continue;
    }
    if (/^\s*(\-|\*|•|·)\s+/.test(line)) {
      if (!inUl) { out += '<ul>'; inUl = true; }
      out += `<li>${line.replace(/^\s*(\-|\*|•|·)\s+/, '')}</li>`;
      continue;
    }
    if (inUl) { out += '</ul>'; inUl = false; }
    if (line.trim().length === 0) { out += '<br/>'; continue; }
    out += `<p>${line}</p>`;
  }
  if (inUl) out += '</ul>';
  return out;
}

function mdToHtmlAdvanced(md: string): string {
  if (!md) return '';
  const applyInline = (s: string): string => {
    let x = escapeHtml(s);
    x = x.replace(/!\[([^\]]*)\]\(([^)]+)\)/g, '<img src="$2" alt="$1" />');
    x = x.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2" target="_blank">$1</a>');
    x = x.replace(/(https?:\/\/[^\s)]+)/g, '<a href="$1" target="_blank">$1</a>');
    x = x.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
    x = x.replace(/\*([^*]+)\*/g, '<em>$1</em>');
    x = x.replace(/`([^`]+)`/g, '<code>$1</code>');
    return x;
  };

  const lines = md.split(/\r?\n/);
  let html = '';
  let codeFence = false;
  let codeBuf: string[] = [];
  let bqDepth = 0;
  const listStack: { type: 'ul' | 'ol'; indent: number; count?: number }[] = [];
  let tableMode = false;
  let tableRows: string[][] = [];
  let tableHasHeader = false;

  const closeLists = (toIndent: number) => {
    while (listStack.length && listStack[listStack.length - 1].indent >= toIndent) {
      const top = listStack.pop()!;
      html += top.type === 'ol' ? '</div>' : '</ul>';
    }
  };

  const setBlockquoteDepth = (depth: number) => {
    while (bqDepth < depth) { html += '<blockquote>'; bqDepth++; }
    while (bqDepth > depth) { html += '</blockquote>'; bqDepth--; }
  };

  const flushTable = () => {
    if (!tableMode) return;
    if (tableRows.length) {
      const header = tableHasHeader ? tableRows.shift() : undefined;
      html += '<table>';
      if (header) {
        html += '<thead><tr>' + header.map(c => `<th>${applyInline(c)}</th>`).join('') + '</tr></thead>';
      }
      html += '<tbody>' + tableRows.map(row => '<tr>' + row.map(c => `<td>${applyInline(c)}</td>`).join('') + '</tr>').join('') + '</tbody>';
      html += '</table>';
    }
    tableMode = false;
    tableRows = [];
    tableHasHeader = false;
  };

  for (let raw of lines) {
    const line = raw.replace(/\s+$/, '');
    if (codeFence) {
      if (/^```\s*$/.test(line)) {
        html += `<pre class="code"><code>${escapeHtml(codeBuf.join('\n'))}</code></pre>`;
        codeFence = false;
        codeBuf = [];
        continue;
      }
      codeBuf.push(raw);
      continue;
    }

    const fenceStart = line.match(/^```(\w+)?\s*$/);
    if (fenceStart) { flushTable(); closeLists(-1); setBlockquoteDepth(0); codeFence = true; continue; }

    const bqMatch = line.match(/^(>+)\s?(.*)$/);
    if (bqMatch) {
      flushTable();
      const depth = bqMatch[1].length;
      setBlockquoteDepth(depth);
      const content = bqMatch[2];
      if (content.trim().length) html += `<p>${applyInline(content)}</p>`;
      continue;
    } else {
      setBlockquoteDepth(0);
    }

    const heading = line.match(/^(#{1,6})\s+(.*)$/);
    if (heading) {
      flushTable(); closeLists(-1);
      const lvl = heading[1].length; const text = heading[2];
      html += `<h${lvl}>${applyInline(text)}</h${lvl}>`;
      continue;
    }

    if (/^\s*$/.test(line)) { flushTable(); html += '<br/>'; continue; }

    const tableSep = /^\s*\|?\s*(:?-{3,}:?)(\s*\|\s*:?-{3,}:?)*\s*\|?\s*$/.test(line);
    const isTableRow = !tableSep && /\|/.test(line) && !/^\s*(\d+\.|[\-\*\+•·])\s+/.test(line);
    if (isTableRow || tableSep) {
      closeLists(-1);
      if (!tableMode) { tableMode = true; tableRows = []; tableHasHeader = false; }
      if (tableSep) { tableHasHeader = true; continue; }
      const cells = line.replace(/^\|/, '').replace(/\|$/, '').split(/\s*\|\s*/);
      tableRows.push(cells);
      continue;
    }

    if (tableMode) { flushTable(); }

    const liOrdered = line.match(/^(\s*)(\d+)\.\s+(.*)$/);
    const liBullet = line.match(/^(\s*)([\-\*\+•·])\s+(.*)$/);
    if (liOrdered || liBullet) {
      let indent = (liOrdered ? liOrdered[1] : liBullet![1]).length;
      const type = liOrdered ? 'ol' : 'ul';
      const content = liOrdered ? liOrdered[3] : liBullet![3];
      let top = listStack[listStack.length - 1];

      // Auto-nest bullets under current ordered list when indent equal
      if (!liOrdered && top && top.type === 'ol' && indent === top.indent) {
        indent = top.indent + 2;
      }

      // When returning to ordered items at same indent while inside a sublist, close sublists
      if (liOrdered) {
        while (top && top.type !== 'ol' && indent <= top.indent) {
          const popped = listStack.pop()!;
          html += popped.type === 'ol' ? '</div>' : '</ul>';
          top = listStack[listStack.length - 1];
        }
      }

      while (listStack.length && indent < listStack[listStack.length - 1].indent) {
        const popped = listStack.pop()!;
        html += popped.type === 'ol' ? '</div>' : '</ul>';
      }
      top = listStack[listStack.length - 1];

      if (!top || top.type !== type || indent > top.indent) {
        const node = { type, indent, count: 0 } as { type: 'ul' | 'ol'; indent: number; count?: number };
        listStack.push(node);
        html += type === 'ol' ? '<div class="ol">' : '<ul>';
        top = node;
      }
      if (type === 'ol') {
        top!.count = (top!.count || 0) + 1;
        html += `<div class="li"><span class="num">${top!.count}.</span><span>${applyInline(content)}</span></div>`;
      } else {
        html += `<li>${applyInline(content)}</li>`;
      }
      continue;
    }

    if (listStack.length) {
      const topCtx = listStack[listStack.length - 1];
      if (topCtx.type === 'ol') {
        html += `<div class="li-sub">${applyInline(line)}</div>`;
      } else {
        html += `<li class="li-sub">${applyInline(line)}</li>`;
      }
      continue;
    }
    closeLists(-1);
    html += `<p>${applyInline(line)}</p>`;
  }

  if (codeFence) {
    html += `<pre class="code"><code>${escapeHtml(codeBuf.join('\n'))}</code></pre>`;
  }
  flushTable();
  while (listStack.length) { const t = listStack.pop()!; html += t.type === 'ol' ? '</div>' : '</ul>'; }
  setBlockquoteDepth(0);
  return html;
}

const scrollBottom = async () => {
  scrollIntoView.value = '' as any;
  await nextTick();
  scrollIntoView.value = endAnchor;
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.content {
  padding: 24rpx 32rpx 24rpx 32rpx;
  box-sizing: border-box;
  width: 100%;
  padding-bottom: 160rpx;
}

.assistant-hero {
  display: flex;
  align-items: center;
  gap: 16rpx;
}

.hero-avatar {
  font-size: 64rpx;
}

.hero-text {
  display: flex;
  flex-direction: column;
}

.hero-title {
  font-size: $font-size-lg;
  color: $text-primary;
  font-weight: bold;
}

.hero-sub {
  font-size: $font-size-sm;
  color: $text-secondary;
}

.quick-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 12rpx;
  margin-top: 12rpx;
}

.tag {
  padding: 8rpx 16rpx;
  background: $bg-color;
  border-radius: 24rpx;
  font-size: $font-size-sm;
  color: $primary-color;
}

.chat-list {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.msg {
  display: flex;
  gap: 12rpx;
}

.msg.user {
  flex-direction: row-reverse;
}

.avatar {
  font-size: 40rpx;
}

.bubble {
  max-width: 80%;
  background: $card-bg;
  border-radius: $border-radius;
  padding: 16rpx;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.05);
}

.text {
  white-space: pre-line;
  font-size: $font-size-base;
  color: $text-primary;
}

.md {
  font-size: $font-size-base;
  color: $text-primary;
}

.md h1,
.md h2,
.md h3 {
  margin: 8rpx 0;
  font-weight: bold;
}

.md ul,
.md ol {
  padding-left: 32rpx;
}

.md .ol {
  padding-left: 32rpx;
}

.md .ol .li {
  display: flex;
  align-items: flex-start;
  gap: 8rpx;
}

.md .ol .num {
  font-weight: bold;
}

.md .li-sub {
  padding-left: 40rpx;
  color: $text-secondary;
}

.md ol {
  list-style: decimal;
}

.md code {
  background: $bg-color;
  padding: 2rpx 6rpx;
  border-radius: 6rpx;
}

.md pre.code {
  background: $bg-color;
  padding: 12rpx;
  border-radius: $border-radius;
  overflow: auto;
}

.md blockquote {
  border-left: 6rpx solid $divider-color;
  margin: 8rpx 0;
  padding-left: 16rpx;
  color: $text-secondary;
}

.md table {
  width: 100%;
  border-collapse: collapse;
  margin: 8rpx 0;
}

.md th,
.md td {
  border: 1rpx solid $divider-color;
  padding: 8rpx;
  text-align: left;
}

.md a {
  color: $primary-color;
  text-decoration: underline;
}

.feedback {
  display: flex;
  gap: 16rpx;
  margin-top: 8rpx;
}

.fb {
  font-size: $font-size-xs;
  color: $text-secondary;
}

.chat-spacer {
  height: 1rpx;
}

.input-fixed {
  position: fixed;
  left: 0;
  right: 0;
  bottom: calc(var(--window-bottom) + 32rpx);
  padding: 16rpx 32rpx;
  background: transparent;
}

.input-bar {
  display: flex;
  align-items: center;
  gap: 12rpx;
  background: #FFFFFF;
  border-radius: 24rpx;
  box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.08);
  padding: 12rpx;
}

.input {
  flex: 1;
  background: $bg-color;
  border-radius: $border-radius;
  padding: 16rpx;
}

.actions {
  display: flex;
  align-items: center;
  gap: 12rpx;
}

.icon {
  font-size: 32rpx;
  color: $text-secondary;
}
</style>
