<template>
  <view class="messages-page">
    <view class="tabs">
      <view 
        v-for="(tab, index) in tabs" 
        :key="index"
        :class="['tab-item', { active: currentTab === index }]"
        @tap="currentTab = index"
      >
        <text class="tab-text">{{ tab.label }}</text>
        <view v-if="tab.badge > 0" class="tab-badge">{{ tab.badge > 99 ? '99+' : tab.badge }}</view>
      </view>
    </view>

    <scroll-view scroll-y class="content">
      <!-- 系统消息 -->
      <view v-if="currentTab === 0" class="message-list">
        <view v-if="systemMessages.length === 0" class="empty">
          <text class="empty-icon">📭</text>
          <text class="empty-text">暂无系统消息</text>
        </view>
        <Card v-for="msg in systemMessages" :key="msg.id" @tap="viewMessage(msg)">
          <view class="message-item">
            <view class="message-header">
              <text class="message-icon">🔔</text>
              <view class="message-info">
                <text class="message-title">{{ msg.title }}</text>
                <text class="message-time">{{ msg.time }}</text>
              </view>
              <view v-if="!msg.read" class="unread-dot"></view>
            </view>
            <text class="message-content">{{ msg.content }}</text>
          </view>
        </Card>
      </view>

      <!-- 学习提醒 -->
      <view v-if="currentTab === 1" class="message-list">
        <view v-if="reminders.length === 0" class="empty">
          <text class="empty-icon">⏰</text>
          <text class="empty-text">暂无学习提醒</text>
        </view>
        <Card v-for="reminder in reminders" :key="reminder.id" @tap="viewMessage(reminder)">
          <view class="message-item">
            <view class="message-header">
              <text class="message-icon">📚</text>
              <view class="message-info">
                <text class="message-title">{{ reminder.title }}</text>
                <text class="message-time">{{ reminder.time }}</text>
              </view>
              <view v-if="!reminder.read" class="unread-dot"></view>
            </view>
            <text class="message-content">{{ reminder.content }}</text>
          </view>
        </Card>
      </view>

      <!-- 互动消息 -->
      <view v-if="currentTab === 2" class="message-list">
        <view v-if="interactions.length === 0" class="empty">
          <text class="empty-icon">💬</text>
          <text class="empty-text">暂无互动消息</text>
        </view>
        <Card v-for="interaction in interactions" :key="interaction.id" @tap="viewMessage(interaction)">
          <view class="message-item">
            <view class="message-header">
              <image class="message-avatar" :src="interaction.avatar" mode="aspectFill" />
              <view class="message-info">
                <text class="message-title">{{ interaction.title }}</text>
                <text class="message-time">{{ interaction.time }}</text>
              </view>
              <view v-if="!interaction.read" class="unread-dot"></view>
            </view>
            <text class="message-content">{{ interaction.content }}</text>
          </view>
        </Card>
      </view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import Card from '@/components/common/Card.vue';
import { useAppStore } from '@/stores/app';
import { useUserStore } from '@/stores/user';
import { storage, StorageKeys } from '@/utils/storage';

const appStore = useAppStore();
const userStore = useUserStore();

const tabs = ref([
  { label: '系统消息', badge: 0 },
  { label: '学习提醒', badge: 0 },
  { label: '互动消息', badge: 0 }
]);

const currentTab = ref(0);

// Mock消息数据
const systemMessages = ref([
  {
    id: 'm001',
    type: 'system',
    title: '系统通知',
    content: '你的作业《一元一次方程巩固练习》已被批改，得分：92/100',
    time: '2小时前',
    read: false
  },
  {
    id: 'm002',
    type: 'system',
    title: '成就解锁',
    content: '恭喜你解锁成就"连续学习7天"，获得积分+100',
    time: '昨天',
    read: false
  },
  {
    id: 'm003',
    type: 'system',
    title: '学习报告',
    content: '本周学习报告已生成，点击查看详细数据',
    time: '3天前',
    read: true
  }
]);

const reminders = ref([
  {
    id: 'r001',
    type: 'reminder',
    title: '作业提醒',
    content: '《古诗词默写与理解》作业将在明天22:00截止，请及时完成',
    time: '1小时前',
    read: false
  },
  {
    id: 'r002',
    type: 'reminder',
    title: '预习提醒',
    content: '《第7章 电磁感应》课前预习任务已发布，建议时长30分钟',
    time: '今天 08:00',
    read: false
  },
  {
    id: 'r003',
    type: 'reminder',
    title: '课程提醒',
    content: '明天10:00有数学课，请提前准备好学习材料',
    time: '昨天 20:00',
    read: true
  }
]);

const interactions = ref([
  {
    id: 'i001',
    type: 'interaction',
    avatar: 'static/avatar/default.svg',
    title: '小王同学回复了你',
    content: '在讨论"第8章函数题目讨论"中回复：函数的单调性判断，主要看导数的正负...',
    time: '30分钟前',
    read: false
  },
  {
    id: 'i002',
    type: 'interaction',
    avatar: 'static/avatar/default.svg',
    title: '学习小组长点赞了你',
    content: '点赞了你的回复"关于函数的单调性判断..."',
    time: '2小时前',
    read: false
  },
  {
    id: 'i003',
    type: 'interaction',
    avatar: 'static/avatar/default.svg',
    title: '英语达人关注了你',
    content: '开始关注你，快去关注TA吧',
    time: '昨天',
    read: true
  }
]);

onMounted(() => {
  updateBadges();
  loadMessages();
});

function loadMessages() {
  // 从本地存储加载消息
  const stored = storage.get(StorageKeys.MESSAGES);
  if (stored) {
    // 合并存储的消息
  }
}

function updateBadges() {
  tabs.value[0].badge = systemMessages.value.filter(m => !m.read).length;
  tabs.value[1].badge = reminders.value.filter(m => !m.read).length;
  tabs.value[2].badge = interactions.value.filter(m => !m.read).length;
}

const viewMessage = (msg: any) => {
  msg.read = true;
  updateBadges();
  
  // 保存到本地存储
  const allMessages = [...systemMessages.value, ...reminders.value, ...interactions.value];
  storage.set(StorageKeys.MESSAGES, allMessages);
  
  // 根据消息类型跳转
  if (msg.type === 'system') {
    if (msg.title.includes('作业')) {
      uni.navigateTo({ url: '/pages/study/homework-detail?id=h001' });
    } else if (msg.title.includes('成就')) {
      uni.navigateTo({ url: '/pages/achievement/index' });
    } else if (msg.title.includes('报告')) {
      uni.navigateTo({ url: '/pages/evaluation/index' });
    }
  } else if (msg.type === 'reminder') {
    if (msg.title.includes('作业')) {
      uni.switchTab({ url: '/pages/study/index' });
      setTimeout(() => uni.$emit('switchTab', { tab: 'homework' }), 100);
    } else if (msg.title.includes('预习')) {
      uni.switchTab({ url: '/pages/study/index' });
      setTimeout(() => uni.$emit('switchTab', { tab: 'preview' }), 100);
    }
  } else if (msg.type === 'interaction') {
    if (msg.title.includes('回复')) {
      uni.navigateTo({ url: '/pages/discover/discussion-detail?id=d001' });
    }
  }
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.messages-page {
  min-height: 100vh;
  background-color: $bg-color;
  display: flex;
  flex-direction: column;
}

.tabs {
  display: flex;
  background: $card-bg;
  padding: 0 32rpx;
  border-bottom: 1rpx solid $divider-color;
}

.tab-item {
  position: relative;
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 88rpx;
}

.tab-text {
  font-size: $font-size-base;
  color: $text-secondary;
  font-weight: 500;
}

.tab-item.active .tab-text {
  color: $primary-color;
  font-weight: bold;
}

.tab-badge {
  position: absolute;
  top: 16rpx;
  right: 20%;
  min-width: 32rpx;
  height: 32rpx;
  padding: 0 8rpx;
  background-color: $error-color;
  border-radius: 16rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: $font-size-xs;
  color: $text-white;
  font-weight: bold;
}

.content {
  flex: 1;
  padding: 24rpx 32rpx;
  box-sizing: border-box;
}

.message-list {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 120rpx 0;
}

.empty-icon {
  font-size: 120rpx;
  margin-bottom: 24rpx;
}

.empty-text {
  font-size: $font-size-base;
  color: $text-placeholder;
}

.message-item {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.message-header {
  display: flex;
  align-items: center;
  gap: 16rpx;
  position: relative;
}

.message-icon {
  font-size: 48rpx;
  flex-shrink: 0;
}

.message-avatar {
  width: 48rpx;
  height: 48rpx;
  border-radius: 24rpx;
  flex-shrink: 0;
}

.message-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4rpx;
}

.message-title {
  font-size: $font-size-base;
  font-weight: bold;
  color: $text-primary;
}

.message-time {
  font-size: $font-size-xs;
  color: $text-placeholder;
}

.unread-dot {
  width: 16rpx;
  height: 16rpx;
  background: $error-color;
  border-radius: 50%;
  flex-shrink: 0;
}

.message-content {
  font-size: $font-size-sm;
  color: $text-secondary;
  line-height: 1.6;
  padding-left: 64rpx;
}
</style>

