<template>
  <view class="study-page">
    <!-- 顶部Tab切换 -->
    <view class="tab-bar">
      <view 
        v-for="(tab, index) in tabs" 
        :key="index"
        :class="['tab-item', { active: currentTab === index }]"
        @tap="switchTab(index)"
      >
        <text class="tab-text">{{ tab.label }}</text>
        <view v-if="tab.badge > 0" class="tab-badge">{{ tab.badge }}</view>
      </view>
      <view class="tab-indicator" :style="{ left: `${currentTab * 33.33}%` }"></view>
    </view>

    <!-- 筛选栏 -->
    <view class="filter-bar">
      <view class="filter-item" @tap="showSubjectPicker = true">
        <text class="filter-text">{{ selectedSubject || '全部学科' }}</text>
        <text class="filter-icon">▼</text>
      </view>
      <view class="filter-item" @tap="showStatusPicker = true">
        <text class="filter-text">{{ selectedStatus || '全部状态' }}</text>
        <text class="filter-icon">▼</text>
      </view>
    </view>

    <!-- 内容区域 -->
    <scroll-view class="content-area" scroll-y>
      <!-- 我的课程 -->
      <view v-if="currentTab === 0" class="course-list">
        <view v-if="filteredCourses.length === 0" class="empty-state">
          <text class="empty-icon">📚</text>
          <text class="empty-text">暂无课程</text>
        </view>
        <view v-else>
          <Card 
            v-for="course in filteredCourses" 
            :key="course.id"
            @click="goToCourseDetail(course)"
          >
            <view class="course-item">
              <image class="course-cover" :src="course.cover" mode="aspectFill" />
              <view class="course-content">
                <text class="course-name">{{ course.name }}</text>
                <text class="course-teacher">{{ course.teacher }} · {{ course.department }}</text>
                <view class="course-progress">
                  <view class="progress-bar">
                    <view class="progress-fill" :style="{ width: `${course.progress}%` }"></view>
                  </view>
                  <text class="progress-text">{{ course.progress }}%</text>
                </view>
                <view class="course-footer">
                  <text class="course-info">{{ course.chapter }}</text>
                  <text class="course-info">{{ course.nextClass }}</text>
                </view>
              </view>
            </view>
          </Card>
        </view>
      </view>

      <!-- 课后作业 -->
      <view v-if="currentTab === 1" class="homework-list">
        <view v-if="filteredHomework.length === 0" class="empty-state">
          <text class="empty-icon">✏️</text>
          <text class="empty-text">暂无作业</text>
        </view>
        <view v-else>
          <Card 
            v-for="homework in filteredHomework" 
            :key="homework.id"
            @click="goToHomeworkDetail(homework)"
          >
            <view class="homework-item">
              <view class="homework-header">
                <text class="homework-title">{{ homework.title }}</text>
                <view :class="['homework-status', homework.status]">
                  {{ homework.statusText }}
                </view>
              </view>
              <view class="homework-meta">
                <text class="homework-subject">{{ homework.subject }}</text>
                <text class="homework-time">截止时间：{{ homework.deadline }}</text>
              </view>
              <view v-if="homework.status === 'pending'" class="homework-countdown">
                <text class="countdown-icon">⏰</text>
                <text class="countdown-text">还剩 {{ homework.remainingTime }}</text>
              </view>
            </view>
          </Card>
        </view>
      </view>

      <!-- 课前预习 -->
      <view v-if="currentTab === 2" class="preview-list">
        <view v-if="filteredPreview.length === 0" class="empty-state">
          <text class="empty-icon">📖</text>
          <text class="empty-text">暂无预习任务</text>
        </view>
        <view v-else>
          <Card 
            v-for="preview in filteredPreview" 
            :key="preview.id"
            @click="goToPreviewDetail(preview)"
          >
            <view class="preview-item">
              <view class="preview-header">
                <text class="preview-title">{{ preview.title }}</text>
                <view :class="['preview-status', preview.status]">
                  {{ preview.statusText }}
                </view>
              </view>
              <view class="preview-meta">
                <text class="preview-subject">{{ preview.subject }}</text>
                <text class="preview-duration">建议时长：{{ preview.duration }}分钟</text>
              </view>
              <view class="preview-content">
                <text class="preview-label">预习内容：</text>
                <view class="content-tags">
                  <text v-for="(item, index) in preview.contents" :key="index" class="content-tag">
                    {{ item }}
                  </text>
                </view>
              </view>
            </view>
          </Card>
        </view>
      </view>
    </scroll-view>

    <!-- 学科选择器 -->
    <picker
      v-if="showSubjectPicker"
      mode="selector"
      :range="subjects"
      @change="onSubjectChange"
      @cancel="showSubjectPicker = false"
    >
      <view></view>
    </picker>

    <!-- 状态选择器 -->
    <picker
      v-if="showStatusPicker"
      mode="selector"
      :range="statuses"
      @change="onStatusChange"
      @cancel="showStatusPicker = false"
    >
      <view></view>
    </picker>
  </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import Card from '@/components/common/Card.vue';

// Tab配置
const tabs = ref([
  { label: '我的课程', badge: 0 },
  { label: '课后作业', badge: 5 },
  { label: '课前预习', badge: 2 }
]);

const currentTab = ref(0);

// 筛选选项
const subjects = ['全部学科', '数学', '物理', '英语', '化学', '语文'];
const statuses = ['全部状态', '进行中', '已完成', '未开始'];

const selectedSubject = ref('');
const selectedStatus = ref('');
const showSubjectPicker = ref(false);
const showStatusPicker = ref(false);

// Mock数据
const courses = ref([
  {
    id: 'c001',
    name: '高等数学（上）',
    teacher: '张教授',
    department: '数学学院',
    subject: '数学',
    cover: '/static/course/math.png',
    progress: 78,
    chapter: '第8章',
    nextClass: '本周3节课',
    status: 'ongoing'
  },
  {
    id: 'c002',
    name: '大学物理',
    teacher: '李老师',
    department: '物理学院',
    subject: '物理',
    cover: '/static/course/physics.png',
    progress: 45,
    chapter: '第5章',
    nextClass: '本周2节课',
    status: 'ongoing'
  },
  {
    id: 'c003',
    name: '英语精读',
    teacher: '王老师',
    department: '外语学院',
    subject: '英语',
    cover: '/static/course/english.png',
    progress: 92,
    chapter: '第12章',
    nextClass: '本周2节课',
    status: 'ongoing'
  }
]);

const homework = ref([
  {
    id: 'h001',
    title: '高等数学作业 - 第8章习题',
    subject: '数学',
    deadline: '2024-11-20 23:59',
    remainingTime: '2天12小时',
    status: 'pending',
    statusText: '待完成'
  },
  {
    id: 'h002',
    title: '大学物理实验报告',
    subject: '物理',
    deadline: '2024-11-18 23:59',
    remainingTime: '12小时',
    status: 'pending',
    statusText: '待完成'
  },
  {
    id: 'h003',
    title: '英语阅读理解练习',
    subject: '英语',
    deadline: '2024-11-15 23:59',
    remainingTime: '-',
    status: 'completed',
    statusText: '已完成'
  }
]);

const preview = ref([
  {
    id: 'p001',
    title: '高等数学 - 第9章预习',
    subject: '数学',
    duration: 30,
    contents: ['函数定义', '函数性质', '函数图像'],
    status: 'pending',
    statusText: '待预习'
  },
  {
    id: 'p002',
    title: '大学物理 - 第6章预习',
    subject: '物理',
    duration: 25,
    contents: ['电磁感应', '楞次定律'],
    status: 'completed',
    statusText: '已完成'
  }
]);

// 过滤数据
const filteredCourses = computed(() => {
  let result = courses.value;
  if (selectedSubject.value && selectedSubject.value !== '全部学科') {
    result = result.filter(c => c.subject === selectedSubject.value);
  }
  return result;
});

const filteredHomework = computed(() => {
  let result = homework.value;
  if (selectedSubject.value && selectedSubject.value !== '全部学科') {
    result = result.filter(h => h.subject === selectedSubject.value);
  }
  if (selectedStatus.value && selectedStatus.value !== '全部状态') {
    const statusMap: Record<string, string> = {
      '进行中': 'pending',
      '已完成': 'completed'
    };
    result = result.filter(h => h.status === statusMap[selectedStatus.value]);
  }
  return result;
});

const filteredPreview = computed(() => {
  let result = preview.value;
  if (selectedSubject.value && selectedSubject.value !== '全部学科') {
    result = result.filter(p => p.subject === selectedSubject.value);
  }
  if (selectedStatus.value && selectedStatus.value !== '全部状态') {
    const statusMap: Record<string, string> = {
      '待预习': 'pending',
      '已完成': 'completed'
    };
    result = result.filter(p => p.status === statusMap[selectedStatus.value]);
  }
  return result;
});

// Tab切换
const switchTab = (index: number) => {
  currentTab.value = index;
  // 重置筛选
  selectedSubject.value = '';
  selectedStatus.value = '';
};

// 筛选器事件
const onSubjectChange = (e: any) => {
  selectedSubject.value = subjects[e.detail.value];
  showSubjectPicker.value = false;
};

const onStatusChange = (e: any) => {
  selectedStatus.value = statuses[e.detail.value];
  showStatusPicker.value = false;
};

// 跳转详情
const goToCourseDetail = (course: any) => {
  uni.navigateTo({
    url: `/pages/study/course-detail?id=${course.id}`
  });
};

const goToHomeworkDetail = (hw: any) => {
  uni.navigateTo({
    url: `/pages/study/homework-detail?id=${hw.id}`
  });
};

const goToPreviewDetail = (pv: any) => {
  uni.navigateTo({
    url: `/pages/study/preview-detail?id=${pv.id}`
  });
};

// 监听全局事件（来自首页快捷入口）
onMounted(() => {
  uni.$on('switchTab', (data: any) => {
    if (data.tab === 'homework') {
      currentTab.value = 1;
    } else if (data.tab === 'preview') {
      currentTab.value = 2;
    }
  });
});
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.study-page {
  min-height: 100vh;
  background-color: $bg-color;
  display: flex;
  flex-direction: column;
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
  position: relative;
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

// 筛选栏
.filter-bar {
  display: flex;
  gap: 24rpx;
  padding: 24rpx 32rpx;
  background-color: $card-bg;
}

.filter-item {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16rpx 24rpx;
  background-color: $bg-color;
  border-radius: $border-radius-small;
  
  .filter-text {
    font-size: $font-size-sm;
    color: $text-primary;
  }
  
  .filter-icon {
    font-size: 20rpx;
    color: $text-placeholder;
  }
}

// 内容区域
.content-area {
  flex: 1;
  padding: 24rpx 32rpx;
}

// 空状态
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 120rpx 0;
  
  .empty-icon {
    font-size: 120rpx;
    margin-bottom: 24rpx;
  }
  
  .empty-text {
    font-size: $font-size-base;
    color: $text-placeholder;
  }
}

// 课程列表
.course-item {
  display: flex;
  gap: 24rpx;
}

.course-cover {
  width: 180rpx;
  height: 120rpx;
  border-radius: $border-radius-small;
  background-color: $divider-color;
  flex-shrink: 0;
}

.course-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.course-name {
  font-size: $font-size-lg;
  font-weight: bold;
  color: $text-primary;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.course-teacher {
  font-size: $font-size-sm;
  color: $text-secondary;
  margin-top: 8rpx;
}

.course-progress {
  display: flex;
  align-items: center;
  gap: 16rpx;
  margin-top: 16rpx;
  
  .progress-bar {
    flex: 1;
    height: 8rpx;
    background-color: $divider-color;
    border-radius: 4rpx;
    overflow: hidden;
  }
  
  .progress-fill {
    height: 100%;
    background: $gradient-primary;
    border-radius: 4rpx;
  }
  
  .progress-text {
    font-size: $font-size-xs;
    color: $primary-color;
    font-weight: bold;
    min-width: 56rpx;
  }
}

.course-footer {
  display: flex;
  gap: 24rpx;
  margin-top: 8rpx;
  
  .course-info {
    font-size: $font-size-xs;
    color: $text-placeholder;
  }
}

// 作业列表
.homework-item {
  .homework-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16rpx;
  }
  
  .homework-title {
    flex: 1;
    font-size: $font-size-lg;
    font-weight: bold;
    color: $text-primary;
    margin-right: 16rpx;
  }
  
  .homework-status {
    padding: 8rpx 16rpx;
    border-radius: 24rpx;
    font-size: $font-size-xs;
    font-weight: bold;
    
    &.pending {
      background-color: rgba(255, 184, 77, 0.1);
      color: $accent-color;
    }
    
    &.completed {
      background-color: rgba(82, 196, 26, 0.1);
      color: $success-color;
    }
  }
  
  .homework-meta {
    display: flex;
    gap: 24rpx;
    margin-bottom: 16rpx;
  }
  
  .homework-subject,
  .homework-time {
    font-size: $font-size-sm;
    color: $text-secondary;
  }
  
  .homework-countdown {
    display: flex;
    align-items: center;
    gap: 8rpx;
    padding: 12rpx 16rpx;
    background-color: rgba(245, 34, 45, 0.05);
    border-radius: $border-radius-small;
    
    .countdown-icon {
      font-size: 28rpx;
    }
    
    .countdown-text {
      font-size: $font-size-sm;
      color: $error-color;
      font-weight: bold;
    }
  }
}

// 预习列表
.preview-item {
  .preview-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16rpx;
  }
  
  .preview-title {
    flex: 1;
    font-size: $font-size-lg;
    font-weight: bold;
    color: $text-primary;
    margin-right: 16rpx;
  }
  
  .preview-status {
    padding: 8rpx 16rpx;
    border-radius: 24rpx;
    font-size: $font-size-xs;
    font-weight: bold;
    
    &.pending {
      background-color: rgba(24, 144, 255, 0.1);
      color: $info-color;
    }
    
    &.completed {
      background-color: rgba(82, 196, 26, 0.1);
      color: $success-color;
    }
  }
  
  .preview-meta {
    display: flex;
    gap: 24rpx;
    margin-bottom: 16rpx;
  }
  
  .preview-subject,
  .preview-duration {
    font-size: $font-size-sm;
    color: $text-secondary;
  }
  
  .preview-content {
    padding: 16rpx;
    background-color: $bg-color;
    border-radius: $border-radius-small;
  }
  
  .preview-label {
    font-size: $font-size-sm;
    color: $text-secondary;
    margin-bottom: 12rpx;
    display: block;
  }
  
  .content-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 12rpx;
  }
  
  .content-tag {
    padding: 8rpx 16rpx;
    background-color: $card-bg;
    border-radius: 24rpx;
    font-size: $font-size-xs;
    color: $text-primary;
  }
}
</style>

