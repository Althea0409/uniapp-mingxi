<template>
  <view class="discover-page">
    <!-- Tab栏 -->
    <view class="tab-bar">
      <view v-for="(tab, index) in tabs" :key="index" :class="['tab-item', { active: currentTab === index }]"
        @tap="currentTab = index">
        <text class="tab-text">{{ tab.label }}</text>
      </view>
      <view class="tab-indicator" :style="{ left: `${currentTab * 33.33}%` }"></view>
    </view>

    <scroll-view class="content-area" scroll-y>
      <!-- 课堂讨论 -->
      <view v-if="currentTab === 0" class="discussion-list">
        <view v-if="discussions.length === 0" class="empty-state">
          <text class="empty-icon">💬</text>
          <text class="empty-text">暂无讨论，快来发起第一个讨论吧！</text>
        </view>
        <Card v-for="item in discussions" :key="item.id" @click="goToDiscussionDetail(item)">
          <view class="discussion-item">
            <view class="discussion-header">
              <image class="avatar" :src="resolveAvatar(item.avatar)" mode="aspectFill" @error="onAvatarError(item)" />
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
        <Card v-for="item in resources" :key="item.id" @click="viewResource(item)">
          <view class="resource-item">
            <image class="resource-cover" :src="item.cover" mode="aspectFill" />
            <view class="resource-content">
              <text class="resource-title">{{ item.title }}</text>
              <text class="resource-desc">{{ item.description }}</text>
              <view class="resource-footer">
                <view :class="['resource-type', item.type]">{{ item.typeName }}</view>
                <text class="resource-time">匹配度{{ item.matchRate }}%</text>
              </view>
              <text v-if="item.reason" class="resource-reason">推荐理由：{{ item.reason }}</text>
            </view>
          </view>
        </Card>
      </view>

      <!-- 知识库 -->
      <view v-if="currentTab === 2" class="knowledge-list">
        <Card v-for="item in knowledgeBase" :key="item.id" @click="viewKnowledge(item)">
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
import { ref, onMounted, computed } from 'vue';
import { useAppStore } from '@/stores/app';
import { useCourseStore } from '@/stores/course';
import { useUserStore } from '@/stores/user';
import { storage, StorageKeys } from '@/utils/storage';
import Card from '@/components/common/Card.vue';
import achievementsJson from '@/mock/achievements.json';
import portraitData from '@/mock/portrait.json';

const appStore = useAppStore();
const userStore = useUserStore();
const currentTab = ref(0);

const baseUrl = import.meta.env.BASE_URL || '/';
const defaultAvatarUrl = new URL('../../static/avatar/default.svg', import.meta.url).href;
function resolveAvatar(src?: string) {
  if (!src) return defaultAvatarUrl;
  if (/^(https?:)?\/\//.test(src) || src.startsWith('data:')) return src;
  if (src.startsWith(baseUrl)) return src;
  if (src.includes('static/avatar/default.svg')) return defaultAvatarUrl;
  const cleanBase = baseUrl.endsWith('/') ? baseUrl : baseUrl + '/';
  if (src.startsWith('/')) return cleanBase.replace(/\/$/, '') + src;
  return cleanBase + src.replace(/^\.?\//, '');
}

const tabs = ref([
  { label: '课堂讨论' },
  { label: '资源推荐' },
  { label: '知识库' }
]);

// 加载讨论列表
const loadDiscussions = () => {
  const mock = [
    {
      id: 'd001',
      avatar: 'static/avatar/default.svg',
      username: '小王同学',
      time: '2小时前',
      isHot: true,
      title: '第8章函数题目讨论',
      content: '关于函数的单调性判断，大家有什么好的技巧吗？题目5特别难，我做了好几遍都没做出来，求大神指点！',
      views: 236,
      replies: 18,
      likes: 42,
      tags: ['数学', '函数', '求助']
    },
    {
      id: 'd002',
      avatar: 'static/avatar/default.svg',
      username: '学习小组长',
      time: '5小时前',
      isHot: false,
      title: '物理实验报告格式分享',
      content: '整理了一份详细的物理实验报告模板，包含所有必要部分：实验目的、原理、步骤、数据记录、结果分析等，需要的同学可以私信我！',
      views: 158,
      replies: 12,
      likes: 28,
      tags: ['物理', '实验', '分享']
    },
    {
      id: 'd003',
      avatar: 'static/avatar/default.svg',
      username: '英语达人',
      time: '昨天',
      isHot: true,
      title: '英语阅读理解技巧总结',
      content: '分享一下我做阅读理解的方法，希望对大家有帮助。主要是先看题目，再读文章，这样效率会高很多。还有就是要抓住关键词，理解文章主旨。',
      views: 412,
      replies: 35,
      likes: 87,
      tags: ['英语', '阅读', '技巧']
    },
    {
      id: 'd004',
      avatar: 'static/avatar/default.svg',
      username: '数学课代表',
      time: '昨天',
      isHot: false,
      title: '一元一次方程解题步骤详解',
      content: '很多同学问一元一次方程怎么解，我总结了一下标准步骤：1.去分母 2.去括号 3.移项 4.合并同类项 5.系数化为1。每一步都要仔细检查！',
      views: 189,
      replies: 15,
      likes: 56,
      tags: ['数学', '方程', '学习技巧']
    },
    {
      id: 'd005',
      avatar: 'static/avatar/default.svg',
      username: '语文爱好者',
      time: '2天前',
      isHot: false,
      title: '古诗词背诵方法分享',
      content: '我发现了一个很好的背诵方法：先理解诗词的意思和背景，然后分段记忆，最后整体串联。这样记得更牢固，不容易忘记。',
      views: 124,
      replies: 8,
      likes: 32,
      tags: ['语文', '古诗词', '背诵']
    },
    {
      id: 'd006',
      avatar: 'static/avatar/default.svg',
      username: '科学探索者',
      time: '2天前',
      isHot: true,
      title: '化学元素周期表记忆口诀',
      content: '分享一个记忆元素周期表的口诀，特别有用！氢氦锂铍硼，碳氮氧氟氖...这样记起来快多了，大家试试看！',
      views: 298,
      replies: 22,
      likes: 71,
      tags: ['化学', '元素周期表', '记忆方法']
    },
    {
      id: 'd007',
      avatar: 'static/avatar/default.svg',
      username: '历史迷',
      time: '3天前',
      isHot: false,
      title: '如何整理历史时间线？',
      content: '历史事件太多，时间线容易搞混。我建议用时间轴的方式整理，把重要事件按时间顺序排列，再标注关键信息，这样复习起来一目了然。',
      views: 156,
      replies: 11,
      likes: 39,
      tags: ['历史', '学习方法', '整理']
    },
    {
      id: 'd008',
      avatar: 'static/avatar/default.svg',
      username: '地理小达人',
      time: '3天前',
      isHot: false,
      title: '中国地理知识速记',
      content: '中国有34个省级行政区，包括23个省、5个自治区、4个直辖市、2个特别行政区。可以用地图配合记忆，效果更好！',
      views: 203,
      replies: 14,
      likes: 48,
      tags: ['地理', '知识', '记忆']
    },
    {
      id: 'd009',
      avatar: 'static/avatar/default.svg',
      username: '生物观察员',
      time: '4天前',
      isHot: false,
      title: '植物细胞结构图绘制技巧',
      content: '画植物细胞结构图时，要注意各个细胞器的位置和形状。细胞壁要画得厚一些，叶绿体要画成椭圆形，细胞核要画在中间位置。',
      views: 167,
      replies: 9,
      likes: 35,
      tags: ['生物', '细胞', '绘图']
    },
    {
      id: 'd010',
      avatar: 'static/avatar/default.svg',
      username: '作业互助组',
      time: '4天前',
      isHot: false,
      title: '周末作业讨论组',
      content: '这周末的作业有点多，大家进度如何？数学作业第3题有点难，有做出来的同学吗？可以一起讨论一下解题思路。',
      views: 145,
      replies: 19,
      likes: 41,
      tags: ['作业', '互助', '讨论']
    }
  ];
  
  // 从本地存储加载新发布的讨论
  const stored = storage.get(StorageKeys.DISCUSSIONS) || [];
  // 合并数据，新发布的在前，模拟数据在后
  discussions.value = [...stored, ...mock];
};

const discussions = ref<any[]>([]);

const courseStore = useCourseStore();

function detectSubject(name: string): string {
  if (!name) return '综合';
  if (name.includes('语文')) return '语文';
  if (name.includes('数学')) return '数学';
  if (name.includes('英语')) return '英语';
  if (name.includes('科学')) return '科学';
  if (name.includes('社政') || name.includes('历史') || name.includes('社会')) return '社政';
  return '综合';
}

function mapTypeName(t: string): { type: string; typeName: string } {
  if (t === 'video' || t === '视频') return { type: 'video', typeName: '视频' };
  if (t === 'audio' || t === '音频') return { type: 'audio', typeName: '音频' };
  if (t === 'exercise' || t === '练习') return { type: 'exercise', typeName: '练习' };
  return { type: 'document', typeName: '文档' };
}

function getCoverByType(t: string): string {
  if (t === 'video') return '/static/resource/video.svg';
  if (t === 'audio') return '/static/resource/audio.svg';
  if (t === 'exercise') return '/static/resource/exercise.svg';
  return '/static/resource/doc.svg';
}

function getSubjectCover(subject: string): string {
  switch (subject) {
    case '语文': return '/static/resource/subject-chinese.svg';
    case '数学': return '/static/resource/subject-math.svg';
    case '英语': return '/static/resource/subject-english.svg';
    case '科学': return '/static/resource/subject-science.svg';
    case '社政': return '/static/resource/subject-history.svg';
    default: return '/static/resource/doc.svg';
  }
}

function detectSubjectFromTitle(title: string): string {
  const t = title || '';
  if (/(语文|古诗|文言|作文)/.test(t)) return '语文';
  if (/(数学|方程|几何|函数|比例)/.test(t)) return '数学';
  if (/(英语|词汇|语法|Unit|阅读)/i.test(t)) return '英语';
  if (/(科学|实验|观察|物理|化学|生物)/.test(t)) return '科学';
  if (/(历史|地理|社会|地图|家乡|社政)/.test(t)) return '社政';
  return '综合';
}

function genRecommendedResources() {
  const base = (achievementsJson as any).resources || [];
  const ongoing = courseStore.ongoingCourses || [];
  const wrong = (appStore as any).consecutiveWrong || 0;
  const byCourse: any[] = [];
  const fallback: any[] = [];
  const subjects = ongoing.map((c: any) => ({
    id: c.id,
    name: c.name,
    subject: detectSubject(c.name),
    progress: c.progress || 0,
  }));

  for (const s of subjects) {
    const pd: any = (portraitData as any)[s.subject];
    if (!pd) continue;
    const lows = [...(pd.classicKnowledge || []), ...(pd.modernKnowledge || [])]
      .filter((x: any) => typeof x.value === 'number' && x.value <= 75)
      .slice(0, 2);
    const resList = (pd.resources || []).slice(0, 2);
    for (const r of resList) {
      const { type, typeName } = mapTypeName(r.type);
      let match = (r.match || r.matchRate || 80);
      if (s.progress >= 60 && lows.length > 0) match = Math.min(98, match + 8);
      if (s.progress < 40) match = Math.max(60, match - 6);
      if (wrong >= 3) match = Math.min(99, match + 5);
      const reasonParts = [] as string[];
      if (lows[0]) reasonParts.push(`“${lows[0].name}”掌握度${lows[0].value}%偏弱`);
      if (s.progress) reasonParts.push(`当前课程进度${s.progress}%`);
      if (wrong >= 3) reasonParts.push('近期错题较多，建议巩固');
      byCourse.push({
        id: `${s.id}-${r.id}`,
        cover: getSubjectCover(s.subject),
        title: r.title,
        description: r.desc || r.description || '',
        type,
        typeName,
        subject: s.subject,
        time: r.duration ? `${r.duration}分钟` : '推荐',
        matchRate: match,
        reason: reasonParts.join('；')
      });
    }
  }

  const mappedBase = (base as any[]).map((r: any) => {
    const { type, typeName } = mapTypeName(r.type);
    const subject = detectSubjectFromTitle(r.title || r.description || '');
    return {
      id: r.id,
      cover: (r.cover && r.cover !== '/static/logo.png')
        ? r.cover
        : (subject === '综合' ? getCoverByType(type) : getSubjectCover(subject)),
      title: r.title,
      description: r.description,
      type,
      typeName,
      subject,
      time: r.duration ? `${r.duration}分钟` : '推荐',
      matchRate: r.matchRate || 85,
      reason: r.reason || '结合学习画像为你推荐'
    };
  });

  const subjectKeys = Object.keys(portraitData || {});
  for (const key of subjectKeys) {
    const pd: any = (portraitData as any)[key];
    const lows = [...(pd.classicKnowledge || []), ...(pd.modernKnowledge || [])]
      .filter((x: any) => typeof x.value === 'number' && x.value <= 75)
      .slice(0, 2);
    const resList = (pd.resources || []).slice(0, 2);
    for (const r of resList) {
      const { type, typeName } = mapTypeName(r.type);
      const baseMatch = (pd.knowledge?.overall || pd.skills?.mastery || 75);
      const match = Math.min(99, Math.max(60, baseMatch + (lows.length > 0 ? 8 : 0)));
      fallback.push({
        id: `pf-${key}-${r.id}`,
        cover: getSubjectCover(key),
        title: r.title,
        description: r.desc || r.description || '',
        type,
        typeName,
        subject: key,
        time: r.duration ? `${r.duration}分钟` : '推荐',
        matchRate: match,
        reason: lows[0] ? `“${lows[0].name}”掌握度${lows[0].value}%偏弱` : `画像整体掌握度${baseMatch}%`
      });
    }
  }

  const merged = [...byCourse, ...mappedBase, ...fallback];
  merged.sort((a, b) => (b.matchRate || 0) - (a.matchRate || 0));
  return merged.slice(0, 12);
}

const resources = ref<any[]>(genRecommendedResources());

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
  const q = encodeURIComponent(item.id);
  appStore.navigateTo(`/pages/discover/resource-detail?id=${q}`);
};
const startResource = (item: any) => {
  appStore.recordStudySession(15);
  currentTab.value = 1;
};

// 查看知识
const viewKnowledge = (item: any) => {
  uni.navigateTo({
    url: `/pages/discover/knowledge-detail?id=${item.id}`
  });
};

// 发帖
const createPost = () => {
  uni.navigateTo({
    url: '/pages/discover/discussion-create'
  });
};

const onAvatarError = (item: any) => {
  item.avatar = 'static/avatar/default.svg';
};

// 监听全局事件
onMounted(async () => {
  loadDiscussions();
  uni.$on('switchTab', (data: any) => {
    if (data.tab === 'discussion') {
      currentTab.value = 0;
    } else if (data.tab === 'resource') {
      currentTab.value = 1;
    }
  });
  try { await (courseStore as any).getCourseList?.(); } catch { }
  resources.value = genRecommendedResources();
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
  padding: 24rpx 32rpx 24rpx 32rpx;
  box-sizing: border-box;
}

// 讨论列表
.discussion-list {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.empty-state {
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

.resource-actions {
  margin-top: 8rpx;
}

.resource-reason {
  display: block;
  margin-top: 8rpx;
  font-size: $font-size-xs;
  color: $primary-color;
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
