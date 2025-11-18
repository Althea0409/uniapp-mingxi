<template>
  <view class="profile-page">
    <!-- 用户信息卡片 -->
    <view class="user-header">
      <view class="user-info-card">
        <view class="user-avatar-wrap" @tap="goToProfile">
          <image class="user-avatar" :src="userStore.userAvatar" mode="aspectFill" />
          <view class="level-badge">Lv{{ userStore.userLevel }}</view>
        </view>
        
        <view class="user-details">
          <text class="user-name">{{ userStore.userName }}</text>
          <text class="user-school">{{ userInfo?.school }} · {{ userInfo?.grade }} {{ userInfo?.class }}</text>
          
          <view class="exp-progress">
            <view class="exp-bar">
              <view class="exp-fill" :style="{ width: `${userStore.userExp}%` }"></view>
            </view>
            <text class="exp-text">{{ userStore.userExp }}/100</text>
          </view>
        </view>
      </view>
      
      <!-- 积分勋章 -->
      <view class="stats-row">
        <view class="stat-item" @tap="goToAchievement">
          <text class="stat-value">{{ userStore.userPoints }}</text>
          <text class="stat-label">积分</text>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item" @tap="goToAchievement">
          <text class="stat-value">{{ userInfo?.badges || 0 }}</text>
          <text class="stat-label">勋章</text>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item" @tap="goToEvaluation">
          <text class="stat-value">{{ studyDays }}</text>
          <text class="stat-label">学习天数</text>
        </view>
      </view>
    </view>

    <!-- 功能入口 -->
    <scroll-view class="content-scroll" scroll-y>
      <!-- 学习相关 -->
      <view class="menu-section">
        <view class="section-title">学习管理</view>
        <Card>
          <view class="menu-list">
            <view 
              v-for="(item, index) in studyMenus"
              :key="index"
              class="menu-item"
              @tap="handleMenuClick(item)"
            >
              <text class="menu-icon">{{ item.icon }}</text>
              <text class="menu-text">{{ item.label }}</text>
              <text class="menu-arrow">→</text>
            </view>
          </view>
        </Card>
      </view>

      <!-- 工具相关 -->
      <view class="menu-section">
        <view class="section-title">学习工具</view>
        <Card>
          <view class="menu-list">
            <view 
              v-for="(item, index) in toolMenus"
              :key="index"
              class="menu-item"
              @tap="handleMenuClick(item)"
            >
              <text class="menu-icon">{{ item.icon }}</text>
              <text class="menu-text">{{ item.label }}</text>
              <text class="menu-arrow">→</text>
            </view>
          </view>
        </Card>
      </view>

      <!-- 设置相关 -->
      <view class="menu-section">
        <view class="section-title">设置</view>
        <Card>
          <view class="menu-list">
            <view 
              v-for="(item, index) in settingMenus"
              :key="index"
              class="menu-item"
              @tap="handleMenuClick(item)"
            >
              <text class="menu-icon">{{ item.icon }}</text>
              <text class="menu-text">{{ item.label }}</text>
              <text class="menu-arrow">→</text>
            </view>
          </view>
        </Card>
      </view>

      <!-- 退出登录按钮 -->
      <view class="logout-section">
        <Button 
          text="退出登录"
          type="secondary"
          size="large"
          @click="handleLogout"
        />
      </view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { useUserStore } from '@/stores/user';
import { useAppStore } from '@/stores/app';
import Card from '@/components/common/Card.vue';
import Button from '@/components/common/Button.vue';

const userStore = useUserStore();
const appStore = useAppStore();

const userInfo = computed(() => userStore.userInfo);
const studyDays = ref(65); // Mock学习天数

// 菜单配置
const studyMenus = ref([
  { icon: '📅', label: '我的课表', url: '/pages/schedule/index' },
  { icon: '📊', label: '学习数据', url: '/pages/evaluation/index' },
  { icon: '🧠', label: '学生画像', url: '/pages/portrait/index' },
  { icon: '🏆', label: '成就勋章', url: '/pages/achievement/index' },
  { icon: '📈', label: '成长档案', url: '/pages/growth/index' }
]);

const toolMenus = ref([
  { icon: '🤖', label: 'AI学习助手', url: '/pages/assistant/index' },
  { icon: '📚', label: '知识库', url: '/pages/discover/index' },
  { icon: '💬', label: '讨论区', url: '/pages/discover/index?tab=discussion' }
]);

const settingMenus = ref([
  { icon: '⚙️', label: '设置', url: '/pages/profile/settings' },
  { icon: '❓', label: '帮助与反馈', action: 'help' },
  { icon: '📝', label: '关于我们', action: 'about' }
]);

// 跳转到个人资料
const goToProfile = () => {
  appStore.showToast('个人资料编辑功能开发中', 'none');
};

// 跳转到成就页
const goToAchievement = () => {
  uni.navigateTo({
    url: '/pages/achievement/index'
  });
};

// 跳转到评估页
const goToEvaluation = () => {
  uni.navigateTo({
    url: '/pages/evaluation/index'
  });
};

// 处理菜单点击
const handleMenuClick = (item: any) => {
  if (item.url) {
    uni.navigateTo({
      url: item.url
    });
  } else if (item.action === 'help') {
    appStore.showToast('帮助与反馈功能开发中', 'none');
  } else if (item.action === 'about') {
    uni.showModal({
      title: '关于我们',
      content: '明蹊智慧学习平台 v1.0.0\n\n致力于为学生提供智能化学习体验',
      showCancel: false
    });
  }
};

// 退出登录
const handleLogout = async () => {
  const confirm = await appStore.showConfirm('确定要退出登录吗？');
  if (confirm) {
    userStore.logout();
  }
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.profile-page {
  min-height: 100vh;
  background-color: $bg-color;
  display: flex;
  flex-direction: column;
}

// 用户信息区域
.user-header {
  background: $gradient-primary;
  padding: calc(var(--status-bar-height) + 32rpx) 32rpx 32rpx;
}

.user-info-card {
  display: flex;
  align-items: center;
  gap: 24rpx;
  margin-bottom: 32rpx;
}

.user-avatar-wrap {
  position: relative;
  flex-shrink: 0;
  
  .user-avatar {
    width: 120rpx;
    height: 120rpx;
    border-radius: 60rpx;
    border: 4rpx solid rgba(255, 255, 255, 0.3);
  }
  
  .level-badge {
    position: absolute;
    bottom: -8rpx;
    left: 50%;
    transform: translateX(-50%);
    min-width: 64rpx;
    height: 32rpx;
    padding: 0 12rpx;
    background: $accent-color;
    border-radius: 16rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: $font-size-xs;
    color: $text-white;
    font-weight: bold;
  }
}

.user-details {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.user-name {
  font-size: $font-size-xxl;
  font-weight: bold;
  color: $text-white;
}

.user-school {
  font-size: $font-size-sm;
  color: rgba(255, 255, 255, 0.8);
}

.exp-progress {
  display: flex;
  align-items: center;
  gap: 16rpx;
  margin-top: 8rpx;
  
  .exp-bar {
    flex: 1;
    height: 16rpx;
    background: rgba(255, 255, 255, 0.3);
    border-radius: 8rpx;
    overflow: hidden;
  }
  
  .exp-fill {
    height: 100%;
    background: $accent-color;
    border-radius: 8rpx;
    transition: width 0.5s ease;
  }
  
  .exp-text {
    font-size: $font-size-xs;
    color: rgba(255, 255, 255, 0.9);
    min-width: 80rpx;
  }
}

// 统计数据行
.stats-row {
  display: flex;
  align-items: center;
  justify-content: space-around;
  padding: 32rpx;
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(10rpx);
  border-radius: $border-radius;
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8rpx;
  cursor: pointer;
  
  .stat-value {
    font-size: $font-size-xxl;
    font-weight: bold;
    color: $text-white;
  }
  
  .stat-label {
    font-size: $font-size-xs;
    color: rgba(255, 255, 255, 0.8);
  }
}

.stat-divider {
  width: 1rpx;
  height: 48rpx;
  background: rgba(255, 255, 255, 0.3);
}

// 内容滚动区域
.content-scroll {
  flex: 1;
  padding: 24rpx 32rpx calc(24rpx + var(--window-bottom)) 32rpx;
  box-sizing: border-box;
}

// 菜单区域
.menu-section {
  margin-bottom: 24rpx;
}

.section-title {
  font-size: $font-size-base;
  font-weight: bold;
  color: $text-secondary;
  margin-bottom: 16rpx;
  padding: 0 8rpx;
}

.menu-list {
  .menu-item {
    display: flex;
    align-items: center;
    padding: 24rpx;
    border-bottom: 1rpx solid $divider-color;
    transition: $transition-fast;
    
    &:last-child {
      border-bottom: none;
    }
    
    &:active {
      background-color: $bg-color;
    }
  }
  
  .menu-icon {
    font-size: 40rpx;
    margin-right: 24rpx;
    flex-shrink: 0;
  }
  
  .menu-text {
    flex: 1;
    font-size: $font-size-base;
    color: $text-primary;
  }
  
  .menu-arrow {
    font-size: $font-size-lg;
    color: $text-placeholder;
  }
}

// 退出登录区域
.logout-section {
  margin-top: 48rpx;
  padding-bottom: 48rpx;
}
</style>

