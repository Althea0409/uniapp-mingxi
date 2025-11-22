<template>
  <view class="discussion-detail-page">
    <Loading v-if="loading" text="正在加载讨论..." />
    <view v-else>
      <!-- 讨论主贴 -->
      <Card>
        <view class="post-header">
          <image class="avatar" :src="discussion.avatar || userStore.userAvatar" mode="aspectFill" />
          <view class="user-info">
            <text class="username">{{ discussion.username }}</text>
            <text class="time">{{ discussion.time }}</text>
          </view>
          <view v-if="discussion.isHot" class="hot-badge">🔥 热门</view>
        </view>
        
        <text class="post-title">{{ discussion.title }}</text>
        <text class="post-content">{{ discussion.content }}</text>
        
        <view class="post-footer">
          <view class="footer-item" @tap="toggleLike">
            <text class="icon">{{ isLiked ? '❤️' : '🤍' }}</text>
            <text class="text">{{ discussion.likes + (isLiked ? 1 : 0) }}</text>
          </view>
          <view class="footer-item">
            <text class="icon">💬</text>
            <text class="text">{{ replies.length }}</text>
          </view>
          <view class="footer-item">
            <text class="icon">👁️</text>
            <text class="text">{{ discussion.views }}</text>
          </view>
        </view>
      </Card>

      <!-- 回复列表 -->
      <Card>
        <view class="section-header">
          <text class="section-title">回复 ({{ replies.length }})</text>
        </view>
        
        <view v-if="replies.length === 0" class="empty-replies">
          <text class="empty-text">暂无回复，快来抢沙发吧~</text>
        </view>
        
        <view v-else class="replies-list">
          <view v-for="reply in replies" :key="reply.id" class="reply-item">
            <image class="reply-avatar" :src="reply.avatar || userStore.userAvatar" mode="aspectFill" />
            <view class="reply-content">
              <view class="reply-header">
                <text class="reply-username">{{ reply.username }}</text>
                <text class="reply-time">{{ reply.time }}</text>
              </view>
              <text class="reply-text">{{ reply.content }}</text>
              <view class="reply-actions">
                <text class="action-btn" @tap="likeReply(reply.id)">{{ reply.liked ? '❤️' : '🤍' }} {{ reply.likes }}</text>
                <text class="action-btn" @tap="replyTo(reply)">回复</text>
              </view>
            </view>
          </view>
        </view>
      </Card>

      <!-- 回复输入框 -->
      <view class="reply-input-bar">
        <input 
          class="reply-input" 
          v-model="replyText" 
          placeholder="写下你的回复..." 
          @confirm="submitReply"
        />
        <Button 
          text="发送" 
          type="primary" 
          size="small" 
          :disabled="!replyText.trim() || submitting"
          @click="submitReply"
        />
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { onLoad } from '@dcloudio/uni-app';
import Card from '@/components/common/Card.vue';
import Button from '@/components/common/Button.vue';
import Loading from '@/components/common/Loading.vue';
import { useAppStore } from '@/stores/app';
import { useUserStore } from '@/stores/user';

const appStore = useAppStore();
const userStore = useUserStore();

const loading = ref(true);
const discussion = ref<any>({});
const replies = ref<any[]>([]);
const isLiked = ref(false);
const replyText = ref('');
const submitting = ref(false);
const replyingTo = ref<any>(null);

// Mock讨论数据
const mockDiscussions: Record<string, any> = {
  'd001': {
    id: 'd001',
    avatar: 'static/avatar/default.svg',
    username: '小王同学',
    time: '2小时前',
    isHot: true,
    title: '第8章函数题目讨论',
    content: '关于函数的单调性判断，大家有什么好的技巧吗？题目5特别难，我做了好久都没做出来。希望有同学能分享一下解题思路。',
    views: 236,
    replies: 18,
    likes: 42
  },
  'd002': {
    id: 'd002',
    avatar: 'static/avatar/default.svg',
    username: '学习小组长',
    time: '5小时前',
    isHot: false,
    title: '物理实验报告格式分享',
    content: '整理了一份详细的物理实验报告模板，包含所有必要部分，希望对大家有帮助。',
    views: 158,
    replies: 12,
    likes: 28
  },
  'd003': {
    id: 'd003',
    avatar: 'static/avatar/default.svg',
    username: '英语达人',
    time: '昨天',
    isHot: true,
    title: '英语阅读理解技巧总结',
    content: '分享一下我做阅读理解的方法，希望对大家有帮助。主要是先看题目，再读文章，这样效率会高很多。',
    views: 412,
    replies: 35,
    likes: 87
  }
};

// Mock回复数据
const mockReplies: Record<string, any[]> = {
  'd001': [
    {
      id: 'r001',
      avatar: 'static/avatar/default.svg',
      username: '数学小助手',
      time: '1小时前',
      content: '函数的单调性判断，主要看导数的正负。如果导数大于0，函数单调递增；如果导数小于0，函数单调递减。',
      likes: 12,
      liked: false
    },
    {
      id: 'r002',
      avatar: 'static/avatar/default.svg',
      username: '学霸同学',
      time: '30分钟前',
      content: '题目5的关键是要先化简，然后利用函数的性质。建议你先把题目中的函数表达式化简一下。',
      likes: 8,
      liked: true
    }
  ],
  'd002': [
    {
      id: 'r003',
      avatar: 'static/avatar/default.svg',
      username: '物理课代表',
      time: '3小时前',
      content: '感谢分享！这个模板很实用，我已经保存了。',
      likes: 5,
      liked: false
    }
  ],
  'd003': [
    {
      id: 'r004',
      avatar: 'static/avatar/default.svg',
      username: '英语老师',
      time: '昨天',
      content: '很好的方法！先看题目确实能提高阅读效率，建议同学们都试试。',
      likes: 25,
      liked: false
    }
  ]
};

function loadDiscussion(id: string) {
  loading.value = true;
  
  // 模拟加载延迟
  setTimeout(() => {
    const data = mockDiscussions[id];
    if (!data) {
      appStore.showToast('讨论不存在', 'none');
      loading.value = false;
      return;
    }
    
    discussion.value = data;
    replies.value = mockReplies[id] || [];
    loading.value = false;
  }, 500);
}

onLoad((options: any) => {
  const id = options?.id || '';
  if (id) {
    loadDiscussion(id);
  } else {
    loading.value = false;
    appStore.showToast('缺少讨论ID', 'none');
  }
});

const toggleLike = () => {
  isLiked.value = !isLiked.value;
  if (isLiked.value) {
    appStore.showToast('已点赞', 'success');
  }
};

const likeReply = (replyId: string) => {
  const reply = replies.value.find(r => r.id === replyId);
  if (reply) {
    reply.liked = !reply.liked;
    if (reply.liked) {
      reply.likes += 1;
    } else {
      reply.likes = Math.max(0, reply.likes - 1);
    }
  }
};

const replyTo = (reply: any) => {
  replyingTo.value = reply;
  replyText.value = `@${reply.username} `;
};

const submitReply = () => {
  if (!replyText.value.trim() || submitting.value) return;
  
  submitting.value = true;
  
  // 模拟提交延迟
  setTimeout(() => {
    const newReply = {
      id: `r${Date.now()}`,
      avatar: userStore.userAvatar,
      username: userStore.userName,
      time: '刚刚',
      content: replyText.value.trim(),
      likes: 0,
      liked: false
    };
    
    replies.value.push(newReply);
    replyText.value = '';
    replyingTo.value = null;
    submitting.value = false;
    
    appStore.showToast('回复成功', 'success');
    userStore.addPoints(5);
  }, 500);
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.discussion-detail-page {
  min-height: 100vh;
  background-color: $bg-color;
  padding: 24rpx 32rpx calc(120rpx + var(--window-bottom)) 32rpx;
  box-sizing: border-box;
}

.post-header {
  display: flex;
  align-items: center;
  gap: 16rpx;
  margin-bottom: 16rpx;
}

.avatar {
  width: 64rpx;
  height: 64rpx;
  border-radius: 32rpx;
}

.user-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4rpx;
}

.username {
  font-size: $font-size-base;
  font-weight: bold;
  color: $text-primary;
}

.time {
  font-size: $font-size-xs;
  color: $text-placeholder;
}

.hot-badge {
  padding: 8rpx 16rpx;
  background-color: rgba(245, 34, 45, 0.1);
  color: $error-color;
  border-radius: 24rpx;
  font-size: $font-size-xs;
  font-weight: bold;
}

.post-title {
  display: block;
  font-size: $font-size-xl;
  font-weight: bold;
  color: $text-primary;
  margin-bottom: 16rpx;
}

.post-content {
  display: block;
  font-size: $font-size-base;
  color: $text-secondary;
  line-height: 1.8;
  margin-bottom: 24rpx;
}

.post-footer {
  display: flex;
  gap: 32rpx;
  padding-top: 16rpx;
  border-top: 1rpx solid $divider-color;
}

.footer-item {
  display: flex;
  align-items: center;
  gap: 8rpx;
  cursor: pointer;
}

.icon {
  font-size: 32rpx;
}

.text {
  font-size: $font-size-sm;
  color: $text-placeholder;
}

.section-header {
  margin-bottom: 16rpx;
}

.section-title {
  font-size: $font-size-lg;
  font-weight: bold;
  color: $text-primary;
}

.empty-replies {
  padding: 48rpx 0;
  text-align: center;
}

.empty-text {
  font-size: $font-size-sm;
  color: $text-placeholder;
}

.replies-list {
  display: flex;
  flex-direction: column;
  gap: 24rpx;
}

.reply-item {
  display: flex;
  gap: 16rpx;
}

.reply-avatar {
  width: 48rpx;
  height: 48rpx;
  border-radius: 24rpx;
  flex-shrink: 0;
}

.reply-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8rpx;
}

.reply-header {
  display: flex;
  align-items: center;
  gap: 12rpx;
}

.reply-username {
  font-size: $font-size-sm;
  font-weight: bold;
  color: $text-primary;
}

.reply-time {
  font-size: $font-size-xs;
  color: $text-placeholder;
}

.reply-text {
  font-size: $font-size-sm;
  color: $text-secondary;
  line-height: 1.6;
}

.reply-actions {
  display: flex;
  gap: 24rpx;
  margin-top: 8rpx;
}

.action-btn {
  font-size: $font-size-xs;
  color: $text-placeholder;
  cursor: pointer;
}

.reply-input-bar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: calc(var(--window-bottom) + 32rpx);
  padding: 16rpx 32rpx;
  background: #FFFFFF;
  border-top: 1rpx solid $divider-color;
  display: flex;
  align-items: center;
  gap: 16rpx;
  box-shadow: 0 -4rpx 12rpx rgba(0, 0, 0, 0.05);
}

.reply-input {
  flex: 1;
  background: $bg-color;
  border-radius: $border-radius;
  padding: 16rpx;
  font-size: $font-size-base;
}
</style>
