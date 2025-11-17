<template>
  <view class="discover-page">
    <!-- Tab栏 -->
    <view class="tab-bar">
      <view 
        v-for="(tab, index) in tabs" 
        :key="index"
        :class="['tab-item', { active: currentTab === index }]"
        @tap="currentTab = index"
      >
        <text class="tab-text">{{ tab.label }}</text>
      </view>
      <view class="tab-indicator" :style="{ left: `${currentTab * 33.33}%` }"></view>
    </view>

    <scroll-view class="content-area" scroll-y>
      <!-- 课堂讨论 -->
      <view v-if="currentTab === 0" class="discussion-list">
        <Card 
          v-for="item in discussions" 
          :key="item.id"
          @click="goToDiscussionDetail(item)"
        >
          <view class="discussion-item">
            <view class="discussion-header">
              <image class="avatar" :src="item.avatar" mode="aspectFill" />
              <view class="user-info">
                <text class="username">{{ item.username }}</text>
                <text class="time">{{ item.time }}</text>
              </view>
              <view :class="['hot-badge', item.isHot ? 'hot' : '']" v-if="item.isHot">
                🔥热门
              </view>
            </view>
            
            <text class="discussion-title">{{ item.title }}</text>
            <text class="discussion-content">{{ item.content }}</text>
            
            <view class="discussion-footer">
              <view class="footer-item">
                <text class="icon">👁️</text>
                <text class="text">{{ item.views }}</text>
              </view>
              <view class="footer-item">
                <text class="icon">💬</text>
                <text class="text">{{ item.replies }}</text>
              </view>
              <view class="footer-item">
                <text class="icon">👍</text>
                <text class="text">{{ item.likes }}</text>
              </view>
            </view>
          </view>
        </Card>
      </view>

      <!-- 资源推荐 -->
      <view v-if="currentTab === 1" class="resource-list">
        <Card 
          v-for="item in resources" 
          :key="item.id"
          @click="viewResource(item)"
        >
          <view class="resource-item">
            <image class="resource-cover" :src="item.cover" mode="aspectFill" />
            <view class="resource-content">
              <text class="resource-title">{{ item.title }}</text>
              <text class="resource-desc">{{ item.description }}</text>
              <view class="resource-footer">
                <view :class="['resource-type', item.type]">{{ item.typeName }}</view>
                <text class="resource-time">{{ item.time }}</text>
              </view>
            </view>
          </view>
        </Card>
      </view>

      <!-- 知识库 -->
      <view v-if="currentTab === 2" class="knowledge-list">
        <Card 
          v-for="item in knowledgeBase" 
          :key="item.id"
          @click="viewKnowledge(item)"
        >
          <view class="knowledge-item">
            <text class="knowledge-icon">{{ item.icon }}</text>
            <view class="knowledge-content">
              <text class="knowledge-title">{{ item.title }}</text>
              <text class="knowledge-desc">{{ item.description }}</text>
              <view class="knowledge-tags">
                <text v-for="tag in item.tags" :key="tag" class="tag">{{ tag }}</text>
              </view>
            </view>
          </view>
        </Card>
      </view>
    </scroll-view>

    <!-- 发帖按钮 -->
    <view v-if="currentTab === 0" class="fab-button" @tap="createPost">
      <text class="fab-icon">✏️</text>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useAppStore } from '@/stores/app';
import Card from '@/components/common/Card.vue';

const appStore = useAppStore();
const currentTab = ref(0);

const tabs = ref([
  { label: '课堂讨论' },
  { label: '资源推荐' },
  { label: '知识库' }
]);

// Mock数据
const discussions = ref([
  {
    id: 'd001',
    avatar: '/static/avatar/default.png',
    username: '小王同学',
    time: '2小时前',
    isHot: true,
    title: '第8章函数题目讨论',
    content: '关于函数的单调性判断，大家有什么好的技巧吗？题目5特别难...',
    views: 236,
    replies: 18,
    likes: 42
  },
  {
    id: 'd002',
    avatar: '/static/avatar/default.png',
    username: '学习小组长',
    time: '5小时前',
    isHot: false,
    title: '物理实验报告格式分享',
    content: '整理了一份详细的物理实验报告模板，包含所有必要部分...',
    views: 158,
    replies: 12,
    likes: 28
  },
  {
    id: 'd003',
    avatar: '/static/avatar/default.png',
    username: '英语达人',
    time: '昨天',
    isHot: true,
    title: '英语阅读理解技巧总结',
    content: '分享一下我做阅读理解的方法，希望对大家有帮助...',
    views: 412,
    replies: 35,
    likes: 87
  }
]);

const resources = ref([
  {
    id: 'r001',
    cover: '/static/resource/video.png',
    title: '高等数学精讲 - 函数与极限',
    description: '详细讲解函数定义域、值域以及极限运算',
    type: 'video',
    typeName: '视频',
    time: '1天前'
  },
  {
    id: 'r002',
    cover: '/static/resource/doc.png',
    title: '物理公式汇总PDF',
    description: '高中物理所有重要公式整理，便于复习',
    type: 'document',
    typeName: '文档',
    time: '3天前'
  },
  {
    id: 'r003',
    cover: '/static/resource/audio.png',
    title: '英语听力训练材料',
    description: 'CET-4级别听力练习，含原文和解析',
    type: 'audio',
    typeName: '音频',
    time: '5天前'
  }
]);

const knowledgeBase = ref([
  {
    id: 'k001',
    icon: '📐',
    title: '数学公式速查',
    description: '常用数学公式、定理、推导过程',
    tags: ['公式', '定理', '数学']
  },
  {
    id: 'k002',
    icon: '🧪',
    title: '化学方程式大全',
    description: '高中化学所有重要方程式及反应条件',
    tags: ['方程式', '化学', '反应']
  },
  {
    id: 'k003',
    icon: '📖',
    title: '英语语法手册',
    description: '系统讲解英语语法规则和用法',
    tags: ['语法', '英语', '写作']
  }
]);

// 跳转讨论详情
const goToDiscussionDetail = (item: any) => {
  uni.navigateTo({
    url: `/pages/discover/discussion-detail?id=${item.id}`
  });
};

// 查看资源
const viewResource = (item: any) => {
  appStore.showToast('资源详情功能开发中', 'none');
};

// 查看知识
const viewKnowledge = (item: any) => {
  appStore.showToast('知识详情功能开发中', 'none');
};

// 发帖
const createPost = () => {
  appStore.showToast('发帖功能开发中', 'none');
};

// 监听全局事件
onMounted(() => {
  uni.$on('switchTab', (data: any) => {
    if (data.tab === 'discussion') {
      currentTab.value = 0;
    }
  });
});
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.discover-page {
  min-height: 100vh;
  background-color: $bg-color;
  display: flex;
  flex-direction: column;
  position: relative;
}

// Tab栏
.tab-bar {
  position: relative;
  display: flex;
  background-color: $card-bg;
  padding: 0 32rpx;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.05);
}

.tab-item {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 88rpx;
  
  .tab-text {
    font-size: $font-size-base;
    color: $text-secondary;
    font-weight: 500;
    transition: $transition-fast;
  }
  
  &.active .tab-text {
    color: $primary-color;
    font-weight: bold;
  }
}

.tab-indicator {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 33.33%;
  height: 6rpx;
  background: $gradient-primary;
  border-radius: 3rpx 3rpx 0 0;
  transition: left 0.3s ease;
}

// 内容区域
.content-area {
  flex: 1;
  padding: 24rpx 32rpx;
}

// 讨论列表
.discussion-item {
  .discussion-header {
    display: flex;
    align-items: center;
    margin-bottom: 16rpx;
  }
  
  .avatar {
    width: 64rpx;
    height: 64rpx;
    border-radius: 32rpx;
    margin-right: 16rpx;
  }
  
  .user-info {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 4rpx;
    
    .username {
      font-size: $font-size-base;
      font-weight: bold;
      color: $text-primary;
    }
    
    .time {
      font-size: $font-size-xs;
      color: $text-placeholder;
    }
  }
  
  .hot-badge {
    padding: 8rpx 16rpx;
    background-color: rgba(245, 34, 45, 0.1);
    color: $error-color;
    border-radius: 24rpx;
    font-size: $font-size-xs;
    font-weight: bold;
  }
  
  .discussion-title {
    display: block;
    font-size: $font-size-lg;
    font-weight: bold;
    color: $text-primary;
    margin-bottom: 12rpx;
  }
  
  .discussion-content {
    display: block;
    font-size: $font-size-sm;
    color: $text-secondary;
    line-height: 1.6;
    margin-bottom: 16rpx;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
  }
  
  .discussion-footer {
    display: flex;
    gap: 32rpx;
    padding-top: 16rpx;
    border-top: 1rpx solid $divider-color;
  }
  
  .footer-item {
    display: flex;
    align-items: center;
    gap: 8rpx;
    
    .icon {
      font-size: 28rpx;
    }
    
    .text {
      font-size: $font-size-sm;
      color: $text-placeholder;
    }
  }
}

// 资源列表
.resource-item {
  display: flex;
  gap: 24rpx;
}

.resource-cover {
  width: 180rpx;
  height: 120rpx;
  border-radius: $border-radius-small;
  background-color: $divider-color;
  flex-shrink: 0;
}

.resource-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.resource-title {
  font-size: $font-size-lg;
  font-weight: bold;
  color: $text-primary;
  margin-bottom: 8rpx;
}

.resource-desc {
  font-size: $font-size-sm;
  color: $text-secondary;
  line-height: 1.5;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.resource-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 12rpx;
}

.resource-type {
  padding: 6rpx 16rpx;
  border-radius: 24rpx;
  font-size: $font-size-xs;
  font-weight: bold;
  
  &.video {
    background-color: rgba(123, 97, 255, 0.1);
    color: $secondary-color;
  }
  
  &.document {
    background-color: rgba(43, 70, 254, 0.1);
    color: $primary-color;
  }
  
  &.audio {
    background-color: rgba(255, 184, 77, 0.1);
    color: $accent-color;
  }
}

.resource-time {
  font-size: $font-size-xs;
  color: $text-placeholder;
}

// 知识库列表
.knowledge-item {
  display: flex;
  gap: 24rpx;
}

.knowledge-icon {
  font-size: 64rpx;
  flex-shrink: 0;
}

.knowledge-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8rpx;
}

.knowledge-title {
  font-size: $font-size-lg;
  font-weight: bold;
  color: $text-primary;
}

.knowledge-desc {
  font-size: $font-size-sm;
  color: $text-secondary;
  line-height: 1.5;
}

.knowledge-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 12rpx;
  margin-top: 8rpx;
}

.tag {
  padding: 6rpx 16rpx;
  background-color: $bg-color;
  border-radius: 24rpx;
  font-size: $font-size-xs;
  color: $text-secondary;
}

// 浮动按钮
.fab-button {
  position: fixed;
  right: 48rpx;
  bottom: calc(120rpx + var(--window-bottom));
  width: 96rpx;
  height: 96rpx;
  background: $gradient-primary;
  border-radius: 48rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 8rpx 24rpx rgba(43, 70, 254, 0.4);
  z-index: 100;
  
  .fab-icon {
    font-size: 48rpx;
  }
  
  &:active {
    transform: scale(0.95);
  }
}
</style>

