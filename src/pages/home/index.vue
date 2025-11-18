<template>
  <view class="home-page">
    <!-- 自定义导航栏 -->
    <view class="custom-navbar">
      <view class="navbar-content">
        <text class="navbar-title">明蹊智能助学</text>
        <view class="navbar-actions">
          <view class="action-icon" @tap="goToMessages">
            <text class="icon">📬</text>
            <view v-if="unreadCount > 0" class="badge">{{ unreadCount > 99 ? '99+' : unreadCount }}</view>
          </view>
        </view>
      </view>
    </view>

    <!-- 页面内容 -->
    <scroll-view class="page-content" scroll-y>
      <!-- 个人信息卡片 -->
      <view class="user-info-section">
        <Card custom-class="user-card">
          <view class="user-card-content">
            <view class="user-avatar-wrap" @tap="goToProfile">
              <image class="user-avatar" :src="userStore.userAvatar" mode="aspectFill" />
              <view class="level-badge">Lv{{ userStore.userLevel }}</view>
            </view>
            
            <view class="user-info">
              <view class="user-name-row">
                <text class="user-name">{{ userStore.userName }}</text>
                <text class="user-grade">{{ userInfo?.grade }} {{ userInfo?.class }}</text>
              </view>
              
              <view class="exp-section">
                <view class="exp-bar">
                  <view class="exp-progress" :style="{ width: `${userStore.userExp}%` }"></view>
                </view>
                <text class="exp-text">{{ userStore.userExp }}/100</text>
              </view>
              
              <view class="user-stats">
                <view class="stat-item" @tap="goToAchievement">
                  <text class="stat-value">{{ userStore.userPoints }}</text>
                  <text class="stat-label">积分</text>
                </view>
                <view class="stat-divider"></view>
                <view class="stat-item" @tap="goToAchievement">
                  <text class="stat-value">{{ userInfo?.badges || 0 }}</text>
                  <text class="stat-label">勋章</text>
                </view>
              </view>
            </view>
          </view>
        </Card>
      </view>

      <!-- 每日激励语 -->
      <view class="encouragement-section">
        <Card custom-class="encouragement-card">
          <view class="encouragement-content">
            <text class="encouragement-icon">✨</text>
            <text class="encouragement-text">{{ encouragement }}</text>
            <text class="refresh-icon" @tap="refreshEncouragement">🔄</text>
          </view>
        </Card>
      </view>

      <!-- 快捷功能宫格 -->
      <view class="quick-actions-section">
        <view class="section-header">
          <text class="section-title">快捷功能</text>
        </view>
        
        <Card>
          <view class="quick-grid">
            <view 
              v-for="(action, index) in quickActions"
              :key="index"
              class="grid-item"
              @tap="handleQuickAction(action)"
            >
              <view class="grid-icon-wrap">
                <text class="grid-icon">{{ action.icon }}</text>
                <view v-if="action.badge > 0" class="grid-badge">{{ action.badge }}</view>
              </view>
              <text class="grid-label">{{ action.label }}</text>
            </view>
          </view>
        </Card>
      </view>

      <!-- 学习指标仪表盘 -->
      <view class="dashboard-section">
        <view class="section-header">
          <text class="section-title">本周学习数据</text>
          <text class="section-more" @tap="goToEvaluation">查看详情 →</text>
        </view>
        
        <Card>
          <view class="dashboard-content">
            <!-- 环形进度图 -->
            <view class="progress-ring">
              <view class="ring-container">
                <!-- 背景圆环 -->
                <view class="ring-bg"></view>
                <!-- 进度圆环 -->
                <view class="ring-progress" :style="{ 
                  background: `conic-gradient(${progressGradient} ${studyProgress * 3.6}deg, transparent 0)` 
                }"></view>
                <!-- 中心内容 -->
                <view class="ring-center">
                  <text class="ring-value">{{ studyProgress }}%</text>
                  <text class="ring-label">完成度</text>
                </view>
              </view>
            </view>
            
            <!-- 数据指标 -->
            <view class="dashboard-stats">
              <view class="stat-row">
                <view class="stat-item-dash">
                  <text class="stat-icon-dash">⏱️</text>
                  <view class="stat-info">
                    <text class="stat-value-dash">{{ studyTime }}h</text>
                    <text class="stat-label-dash">学习时长</text>
                  </view>
                </view>
                <view class="stat-item-dash">
                  <text class="stat-icon-dash">📚</text>
                  <view class="stat-info">
                    <text class="stat-value-dash">{{ completedCourses }}/{{ totalCourses }}</text>
                    <text class="stat-label-dash">完成课程</text>
                  </view>
                </view>
              </view>
              
              <view class="stat-row">
                <view class="stat-item-dash">
                  <text class="stat-icon-dash">✅</text>
                  <view class="stat-info">
                    <text class="stat-value-dash">{{ completedHomework }}</text>
                    <text class="stat-label-dash">完成作业</text>
                  </view>
                </view>
                <view class="stat-item-dash">
                  <text class="stat-icon-dash">🎯</text>
                  <view class="stat-info">
                    <text class="stat-value-dash">{{ earnedPoints }}</text>
                    <text class="stat-label-dash">获得积分</text>
                  </view>
                </view>
              </view>
            </view>
          </view>
        </Card>
      </view>

      <!-- 推荐课程轮播 -->
      <view class="course-swiper-section">
        <view class="section-header">
          <text class="section-title">推荐课程</text>
          <text class="section-more" @tap="goToStudyCenter">查看更多 →</text>
        </view>
        
        <swiper 
          class="course-swiper"
          :indicator-dots="true"
          :autoplay="true"
          :interval="5000"
          :duration="500"
          :circular="true"
          indicator-color="rgba(0,0,0,0.3)"
          indicator-active-color="#2B46FE"
        >
          <swiper-item v-for="(course, index) in recommendCourses" :key="index">
            <view class="course-item" @tap="goToCourseDetail(course)">
              <Card custom-class="course-card">
                <view class="course-cover-wrap">
                  <image 
                    class="course-cover" 
                    :src="course.cover || '/static/course/default.png'" 
                    mode="aspectFill"
                  />
                  <view class="course-tag">
                    <text class="tag-text">{{ course.tag }}</text>
                  </view>
                </view>
                
                <view class="course-info">
                  <text class="course-name">{{ course.name }}</text>
                  <text class="course-teacher">{{ course.teacher }} · {{ course.department }}</text>
                  
                  <view class="course-progress-wrap">
                    <view class="progress-bar-small">
                      <view 
                        class="progress-fill" 
                        :style="{ width: `${course.progress}%` }"
                      ></view>
                    </view>
                    <text class="progress-text">{{ course.progress }}%</text>
                  </view>
                  
                  <view class="course-meta">
                    <text class="meta-item">📖 {{ course.chapter }}</text>
                    <text class="meta-item">⏰ {{ course.nextClass }}</text>
                  </view>
                </view>
              </Card>
            </view>
          </swiper-item>
        </swiper>
      </view>

      <!-- 占位内容，其他模块待开发 -->
      <view class="placeholder-section">
        <Card>
          <text class="placeholder-text">今日学习动态等功能开发中...</text>
        </Card>
      </view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useUserStore } from '@/stores/user';
import { useAppStore } from '@/stores/app';
import Card from '@/components/common/Card.vue';

const userStore = useUserStore();
const appStore = useAppStore();

// 状态
const unreadCount = ref(3); // Mock未读消息数
const encouragement = ref('');
const userInfo = computed(() => userStore.userInfo);

// 快捷功能配置
const quickActions = ref([
  {
    icon: '📅',
    label: '我的课表',
    badge: 0,
    url: '/pages/schedule/index'
  },
  {
    icon: '📝',
    label: '课后作业',
    badge: 5,
    url: '/pages/study/index?tab=homework'
  },
  {
    icon: '📖',
    label: '课前预习',
    badge: 2,
    url: '/pages/study/index?tab=preview'
  },
  {
    icon: '🧭',
    label: '学习路径',
    badge: 1,
    url: '/pages/plan/index'
  }
]);

// 学习数据
const studyProgress = ref(75); // 本周完成度
const studyTime = ref(12.5); // 本周学习时长
const totalCourses = ref(8); // 总课程数
const completedCourses = ref(6); // 完成课程数
const completedHomework = ref(15); // 完成作业数
const earnedPoints = ref(320); // 获得积分

// 环形进度渐变色
const progressGradient = computed(() => {
  return 'linear-gradient(135deg, #2B46FE, #7B61FF)';
});

// 推荐课程数据
const recommendCourses = ref([
  {
    id: 'c001',
    name: '高等数学（上）',
    teacher: '张教授',
    department: '数学学院',
    cover: '/static/course/math.png',
    progress: 78,
    chapter: '第8章',
    nextClass: '本周3节课',
    tag: '进行中'
  },
  {
    id: 'c002',
    name: '大学物理',
    teacher: '李老师',
    department: '物理学院',
    cover: '/static/course/physics.png',
    progress: 45,
    chapter: '第5章',
    nextClass: '本周2节课',
    tag: '进行中'
  },
  {
    id: 'c003',
    name: '英语精读',
    teacher: '王老师',
    department: '外语学院',
    cover: '/static/course/english.png',
    progress: 92,
    chapter: '第12章',
    nextClass: '本周2节课',
    tag: '即将完成'
  }
]);

// 刷新激励语
const refreshEncouragement = () => {
  encouragement.value = appStore.getRandomEncouragement();
  // 添加触觉反馈
  uni.vibrateShort({
    type: 'light'
  });
};

// 跳转到消息页面
const goToMessages = () => {
  appStore.showToast('消息功能开发中', 'none');
};

// 跳转到个人中心
const goToProfile = () => {
  uni.switchTab({
    url: '/pages/profile/index'
  });
};

// 跳转到成就页面
const goToAchievement = () => {
  uni.navigateTo({
    url: '/pages/achievement/index'
  });
};

// 处理快捷功能点击
const handleQuickAction = (action: any) => {
  if (action.url) {
    // 判断是否是 TabBar 页面
    if (action.url.startsWith('/pages/study/index') || action.url.startsWith('/pages/discover/index')) {
      const [path, query] = action.url.split('?');
      if (query) {
        // 先跳转到TabBar页面，再通过事件传递参数
        uni.switchTab({
          url: path,
          success: () => {
            // 通过全局事件传递Tab参数
            uni.$emit('switchTab', { tab: query.split('=')[1] });
          }
        });
      } else {
        uni.switchTab({ url: path });
      }
    } else {
      uni.navigateTo({ url: action.url });
    }
  }
};

// 跳转到学习评估页
const goToEvaluation = () => {
  uni.navigateTo({
    url: '/pages/evaluation/index'
  });
};

// 跳转到学习中心
const goToStudyCenter = () => {
  uni.switchTab({
    url: '/pages/study/index'
  });
};

// 跳转到课程详情
const goToCourseDetail = (course: any) => {
  uni.navigateTo({
    url: `/pages/study/course-detail?id=${course.id}`
  });
};

// 页面加载
onMounted(() => {
  // 获取激励语
  encouragement.value = appStore.getRandomEncouragement();
  
  // 检查用户信息
  if (!userStore.isLogin) {
    uni.reLaunch({
      url: '/pages/auth/login'
    });
  }
});
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.home-page {
  min-height: 100vh;
  background-color: $bg-color;
}

// 自定义导航栏
.custom-navbar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  background: $gradient-primary;
  z-index: $z-index-navbar;
  padding-top: var(--status-bar-height);
}

.navbar-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 88rpx;
  padding: 0 32rpx;
}

.navbar-title {
  font-size: $font-size-xl;
  font-weight: bold;
  color: $text-white;
}

.navbar-actions {
  display: flex;
  align-items: center;
  gap: 24rpx;
}

.action-icon {
  position: relative;
  width: 48rpx;
  height: 48rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  
  .icon {
    font-size: 40rpx;
  }
  
  .badge {
    position: absolute;
    top: -8rpx;
    right: -8rpx;
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
}

// 页面内容
.page-content {
  height: calc(100vh - 88rpx - var(--status-bar-height));
  margin-top: calc(88rpx + var(--status-bar-height));
  padding: 24rpx 32rpx calc(24rpx + var(--window-bottom)) 32rpx;
  box-sizing: border-box;
}

// 用户信息卡片
.user-info-section {
  margin-bottom: 24rpx;
}

.user-card {
  background: $gradient-primary;
  padding: 32rpx !important;
}

.user-card-content {
  display: flex;
  gap: 24rpx;
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
    box-shadow: 0 4rpx 8rpx rgba(0, 0, 0, 0.1);
  }
}

.user-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 16rpx;
}

.user-name-row {
  display: flex;
  align-items: center;
  gap: 16rpx;
  
  .user-name {
    font-size: $font-size-xl;
    font-weight: bold;
    color: $text-white;
  }
  
  .user-grade {
    font-size: $font-size-sm;
    color: rgba(255, 255, 255, 0.8);
    padding: 4rpx 16rpx;
    background: rgba(255, 255, 255, 0.2);
    border-radius: 24rpx;
  }
}

.exp-section {
  display: flex;
  align-items: center;
  gap: 16rpx;
  
  .exp-bar {
    flex: 1;
    height: 16rpx;
    background: rgba(255, 255, 255, 0.3);
    border-radius: 8rpx;
    overflow: hidden;
  }
  
  .exp-progress {
    height: 100%;
    background: $accent-color;
    border-radius: 8rpx;
    transition: width 0.5s ease;
  }
  
  .exp-text {
    font-size: $font-size-xs;
    color: rgba(255, 255, 255, 0.9);
    min-width: 80rpx;
    text-align: right;
  }
}

.user-stats {
  display: flex;
  align-items: center;
  gap: 24rpx;
  
  .stat-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 4rpx;
  }
  
  .stat-value {
    font-size: $font-size-lg;
    font-weight: bold;
    color: $text-white;
  }
  
  .stat-label {
    font-size: $font-size-xs;
    color: rgba(255, 255, 255, 0.8);
  }
  
  .stat-divider {
    width: 1rpx;
    height: 32rpx;
    background: rgba(255, 255, 255, 0.3);
  }
}

// 激励语卡片
.encouragement-section {
  margin-bottom: 24rpx;
}

.encouragement-card {
  background: linear-gradient(135deg, #FFE5B4, #FFB84D);
}

.encouragement-content {
  display: flex;
  align-items: center;
  gap: 16rpx;
  padding: 16rpx 0;
  
  .encouragement-icon {
    font-size: 40rpx;
    flex-shrink: 0;
  }
  
  .encouragement-text {
    flex: 1;
    font-size: $font-size-base;
    color: $text-primary;
    line-height: 1.6;
    font-weight: 500;
  }
  
  .refresh-icon {
    font-size: 32rpx;
    flex-shrink: 0;
    cursor: pointer;
    transition: transform 0.3s ease;
    
    &:active {
      transform: rotate(180deg);
    }
  }
}

// 快捷功能宫格
.quick-actions-section {
  margin-bottom: 24rpx;
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16rpx;
  padding: 0 8rpx;
  
  .section-title {
    font-size: $font-size-lg;
    font-weight: bold;
    color: $text-primary;
  }
}

.quick-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 0;
}

.grid-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 32rpx 16rpx;
  position: relative;
  transition: $transition-fast;
  
  &:active {
    background-color: $bg-color;
    border-radius: $border-radius;
  }
}

.grid-icon-wrap {
  position: relative;
  margin-bottom: 16rpx;
  
  .grid-icon {
    font-size: 56rpx;
    display: block;
  }
  
  .grid-badge {
    position: absolute;
    top: -8rpx;
    right: -16rpx;
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
    box-shadow: 0 2rpx 8rpx rgba(245, 34, 45, 0.3);
  }
}

.grid-label {
  font-size: $font-size-sm;
  color: $text-secondary;
  text-align: center;
}

// 学习指标仪表盘
.dashboard-section {
  margin-bottom: 24rpx;
  
  .section-more {
    font-size: $font-size-sm;
    color: $primary-color;
    cursor: pointer;
  }
}

.dashboard-content {
  display: flex;
  gap: 32rpx;
  padding: 16rpx 0;
}

// 环形进度图
.progress-ring {
  flex-shrink: 0;
}

.ring-container {
  position: relative;
  width: 200rpx;
  height: 200rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.ring-bg {
  position: absolute;
  width: 100%;
  height: 100%;
  border-radius: 50%;
  background: conic-gradient($divider-color 0deg, $divider-color 360deg);
  mask: radial-gradient(transparent 65%, black 65%);
  -webkit-mask: radial-gradient(transparent 65%, black 65%);
}

.ring-progress {
  position: absolute;
  width: 100%;
  height: 100%;
  border-radius: 50%;
  mask: radial-gradient(transparent 65%, black 65%);
  -webkit-mask: radial-gradient(transparent 65%, black 65%);
  transform: rotate(-90deg);
}

.ring-center {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  z-index: 1;
}

.ring-value {
  font-size: 48rpx;
  font-weight: bold;
  color: $primary-color;
  line-height: 1;
  margin-bottom: 8rpx;
}

.ring-label {
  font-size: $font-size-xs;
  color: $text-secondary;
}

// 数据指标
.dashboard-stats {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  gap: 24rpx;
}

.stat-row {
  display: flex;
  gap: 24rpx;
}

.stat-item-dash {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 16rpx;
  padding: 16rpx;
  background: $bg-color;
  border-radius: $border-radius-small;
}

.stat-icon-dash {
  font-size: 40rpx;
  flex-shrink: 0;
}

.stat-info {
  display: flex;
  flex-direction: column;
  gap: 4rpx;
}

.stat-value-dash {
  font-size: $font-size-lg;
  font-weight: bold;
  color: $text-primary;
  line-height: 1;
}

.stat-label-dash {
  font-size: $font-size-xs;
  color: $text-secondary;
}

// 推荐课程轮播
.course-swiper-section {
  margin-bottom: 24rpx;
}

.course-swiper {
  height: 480rpx;
  margin-top: 16rpx;
}

.course-item {
  padding: 0 8rpx;
}

.course-card {
  height: 100%;
  padding: 0 !important;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.course-cover-wrap {
  position: relative;
  width: 100%;
  height: 220rpx;
  overflow: hidden;
}

.course-cover {
  width: 100%;
  height: 100%;
  background-color: $divider-color;
}

.course-tag {
  position: absolute;
  top: 16rpx;
  right: 16rpx;
  padding: 8rpx 16rpx;
  background: rgba(43, 70, 254, 0.9);
  backdrop-filter: blur(8rpx);
  border-radius: 24rpx;
}

.tag-text {
  font-size: $font-size-xs;
  color: $text-white;
  font-weight: bold;
}

.course-info {
  padding: 24rpx;
  flex: 1;
  overflow: hidden;
}

.course-name {
  display: block;
  font-size: $font-size-lg;
  font-weight: bold;
  color: $text-primary;
  margin-bottom: 8rpx;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.course-teacher {
  display: block;
  font-size: $font-size-sm;
  color: $text-secondary;
  margin-bottom: 16rpx;
}

.course-progress-wrap {
  display: flex;
  align-items: center;
  gap: 16rpx;
  margin-bottom: 16rpx;
}

.progress-bar-small {
  flex: 1;
  height: 12rpx;
  background-color: $divider-color;
  border-radius: 6rpx;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: $gradient-primary;
  border-radius: 6rpx;
  transition: width 0.5s ease;
}

.progress-text {
  font-size: $font-size-xs;
  color: $primary-color;
  font-weight: bold;
  min-width: 56rpx;
  text-align: right;
}

.course-meta {
  display: flex;
  gap: 24rpx;
}

.meta-item {
  font-size: $font-size-xs;
  color: $text-placeholder;
}

// 占位内容
.placeholder-section {
  .placeholder-text {
    display: block;
    text-align: center;
    padding: 48rpx 0;
    font-size: $font-size-base;
    color: $text-placeholder;
  }
}
</style>

