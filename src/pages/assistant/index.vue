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
              <text class="text">{{ m.text }}</text>
              <view v-if="m.role==='assistant'" class="feedback">
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
          <Button :text="sending ? '发送中' : '发送'" :type="sending ? 'secondary' : 'primary'" size="small" :disabled="sending" @click="send" />
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
const messages = ref<{ role: 'user'|'assistant'; text: string }[]>([
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

const scrollBottom = async () => {
  scrollIntoView.value = '' as any;
  await nextTick();
  scrollIntoView.value = endAnchor;
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.content { padding: 24rpx 32rpx 24rpx 32rpx; box-sizing: border-box; width: 100%; padding-bottom: 160rpx; }

.assistant-hero { display: flex; align-items: center; gap: 16rpx; }
.hero-avatar { font-size: 64rpx; }
.hero-text { display: flex; flex-direction: column; }
.hero-title { font-size: $font-size-lg; color: $text-primary; font-weight: bold; }
.hero-sub { font-size: $font-size-sm; color: $text-secondary; }

.quick-tags { display: flex; flex-wrap: wrap; gap: 12rpx; margin-top: 12rpx; }
.tag { padding: 8rpx 16rpx; background: $bg-color; border-radius: 24rpx; font-size: $font-size-sm; color: $primary-color; }

.chat-list { display: flex; flex-direction: column; gap: 16rpx; }
.msg { display: flex; gap: 12rpx; }
.msg.user { flex-direction: row-reverse; }
.avatar { font-size: 40rpx; }
.bubble { max-width: 80%; background: $card-bg; border-radius: $border-radius; padding: 16rpx; box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.05); }
.text { white-space: pre-line; font-size: $font-size-base; color: $text-primary; }
.feedback { display: flex; gap: 16rpx; margin-top: 8rpx; }
.fb { font-size: $font-size-xs; color: $text-secondary; }

.chat-spacer { height: 1rpx; }
.input-fixed { position: fixed; left: 0; right: 0; bottom: calc(var(--window-bottom) + 32rpx); padding: 16rpx 32rpx; background: transparent; }
.input-bar { display: flex; align-items: center; gap: 12rpx; background: #FFFFFF; border-radius: 24rpx; box-shadow: 0 8rpx 24rpx rgba(0,0,0,0.08); padding: 12rpx; }
.input { flex: 1; background: $bg-color; border-radius: $border-radius; padding: 16rpx; }
.actions { display: flex; align-items: center; gap: 12rpx; }
.icon { font-size: 32rpx; color: $text-secondary; }
</style>

