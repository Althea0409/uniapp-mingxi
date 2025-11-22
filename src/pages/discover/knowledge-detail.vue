<template>
  <view class="knowledge-detail-page">
    <Loading v-if="loading" text="正在加载..." />
    <view v-else>
      <Card>
        <view class="header">
          <text class="icon">{{ knowledge.icon }}</text>
          <view class="info">
            <text class="title">{{ knowledge.title }}</text>
            <text class="desc">{{ knowledge.description }}</text>
            <view class="tags">
              <text v-for="tag in knowledge.tags" :key="tag" class="tag">{{ tag }}</text>
            </view>
          </view>
        </view>
      </Card>

      <Card>
        <view class="section">
          <text class="section-title">📚 知识内容</text>
          <view class="content">
            <view v-for="(item, index) in content" :key="index" class="content-item">
              <text class="item-title">{{ item.title }}</text>
              <text class="item-text">{{ item.content }}</text>
              <view v-if="item.examples && item.examples.length" class="examples">
                <text class="example-title">示例：</text>
                <view v-for="(ex, i) in item.examples" :key="i" class="example">
                  <text class="example-text">{{ ex }}</text>
                </view>
              </view>
            </view>
          </view>
        </view>
      </Card>

      <Card>
        <view class="section">
          <text class="section-title">💡 学习建议</text>
          <view class="suggestions">
            <text v-for="(suggestion, index) in suggestions" :key="index" class="suggestion">
              {{ index + 1 }}. {{ suggestion }}
            </text>
          </view>
        </view>
      </Card>

      <Card>
        <view class="actions">
          <Button text="收藏" type="secondary" size="large" @click="toggleFavorite" />
          <Button text="分享" type="secondary" size="large" @click="share" />
        </view>
      </Card>
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
import { storage, StorageKeys } from '@/utils/storage';

const appStore = useAppStore();
const userStore = useUserStore();

const loading = ref(true);
const knowledge = ref<any>({});
const content = ref<any[]>([]);
const suggestions = ref<string[]>([]);
const isFavorite = ref(false);

// Mock知识库数据
const knowledgeData: Record<string, any> = {
  'k001': {
    id: 'k001',
    icon: '📐',
    title: '数学公式速查',
    description: '常用数学公式、定理、推导过程',
    tags: ['公式', '定理', '数学'],
    content: [
      {
        title: '一元一次方程',
        content: '形如 ax + b = 0 (a ≠ 0) 的方程称为一元一次方程。解法：移项、合并同类项、系数化为1。',
        examples: ['2x + 3 = 7', '解：2x = 7 - 3 = 4，所以 x = 2']
      },
      {
        title: '二元一次方程组',
        content: '含有两个未知数，且未知数的次数都是1的方程组。常用解法：代入法、加减消元法。',
        examples: ['{ x + y = 5, 2x - y = 1 }', '解：由第一个方程得 y = 5 - x，代入第二个方程求解']
      },
      {
        title: '勾股定理',
        content: '在直角三角形中，两直角边的平方和等于斜边的平方。即 a² + b² = c²。',
        examples: ['若 a = 3, b = 4，则 c = √(3² + 4²) = 5']
      }
    ],
    suggestions: [
      '熟记基本公式，理解推导过程',
      '多做练习题，掌握应用技巧',
      '注意公式的适用条件',
      '定期复习，巩固记忆'
    ]
  },
  'k002': {
    id: 'k002',
    icon: '🧪',
    title: '化学方程式大全',
    description: '高中化学所有重要方程式及反应条件',
    tags: ['方程式', '化学', '反应'],
    content: [
      {
        title: '化合反应',
        content: '两种或两种以上物质生成一种物质的反应。',
        examples: ['2H₂ + O₂ → 2H₂O', 'C + O₂ → CO₂']
      },
      {
        title: '分解反应',
        content: '一种物质分解成两种或两种以上物质的反应。',
        examples: ['2H₂O → 2H₂ + O₂', 'CaCO₃ → CaO + CO₂']
      }
    ],
    suggestions: [
      '理解反应原理',
      '掌握配平方法',
      '注意反应条件',
      '多做实验验证'
    ]
  },
  'k003': {
    id: 'k003',
    icon: '📖',
    title: '英语语法手册',
    description: '系统讲解英语语法规则和用法',
    tags: ['语法', '英语', '写作'],
    content: [
      {
        title: '一般现在时',
        content: '表示经常性、习惯性的动作或现在的状态。结构：主语 + 动词原形/第三人称单数形式。',
        examples: ['I go to school every day.', 'He likes playing basketball.']
      },
      {
        title: '一般过去时',
        content: '表示过去发生的动作或状态。结构：主语 + 动词过去式。',
        examples: ['I went to the park yesterday.', 'She studied English last night.']
      }
    ],
    suggestions: [
      '理解时态的基本概念',
      '掌握各种时态的结构',
      '通过阅读和写作练习',
      '注意不规则动词的变化'
    ]
  }
};

function loadKnowledge(id: string) {
  loading.value = true;
  
  setTimeout(() => {
    const data = knowledgeData[id];
    if (!data) {
      appStore.showToast('知识不存在', 'none');
      loading.value = false;
      return;
    }
    
    knowledge.value = data;
    content.value = data.content || [];
    suggestions.value = data.suggestions || [];
    
    // 检查是否已收藏
    const favorites = storage.get(StorageKeys.FAVORITES) || [];
    isFavorite.value = favorites.includes(id);
    
    loading.value = false;
  }, 500);
}

onLoad((options: any) => {
  const id = options?.id || '';
  if (id) {
    loadKnowledge(id);
  } else {
    loading.value = false;
    appStore.showToast('缺少知识ID', 'none');
  }
});

const toggleFavorite = () => {
  const favorites = storage.get(StorageKeys.FAVORITES) || [];
  const index = favorites.indexOf(knowledge.value.id);
  
  if (index >= 0) {
    favorites.splice(index, 1);
    isFavorite.value = false;
    appStore.showToast('已取消收藏', 'success');
  } else {
    favorites.push(knowledge.value.id);
    isFavorite.value = true;
    appStore.showToast('已收藏', 'success');
  }
  
  storage.set(StorageKeys.FAVORITES, favorites);
};

const share = () => {
  uni.share({
    provider: 'weixin',
    scene: 'WXSceneSession',
    type: 0,
    href: '',
    title: knowledge.value.title,
    summary: knowledge.value.description,
    success: () => {
      appStore.showToast('分享成功', 'success');
    },
    fail: () => {
      appStore.showToast('分享失败', 'none');
    }
  });
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.knowledge-detail-page {
  min-height: 100vh;
  background-color: $bg-color;
  padding: 24rpx 32rpx calc(24rpx + var(--window-bottom)) 32rpx;
  box-sizing: border-box;
}

.header {
  display: flex;
  gap: 24rpx;
}

.icon {
  font-size: 80rpx;
  flex-shrink: 0;
}

.info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.title {
  font-size: $font-size-xl;
  font-weight: bold;
  color: $text-primary;
}

.desc {
  font-size: $font-size-sm;
  color: $text-secondary;
  line-height: 1.6;
}

.tags {
  display: flex;
  gap: 12rpx;
  flex-wrap: wrap;
  margin-top: 8rpx;
}

.tag {
  padding: 6rpx 16rpx;
  background: $bg-color;
  border-radius: 24rpx;
  font-size: $font-size-xs;
  color: $text-secondary;
}

.section {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.section-title {
  font-size: $font-size-lg;
  font-weight: bold;
  color: $text-primary;
}

.content {
  display: flex;
  flex-direction: column;
  gap: 24rpx;
}

.content-item {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
  padding: 16rpx;
  background: $bg-color;
  border-radius: $border-radius;
}

.item-title {
  font-size: $font-size-base;
  font-weight: bold;
  color: $primary-color;
}

.item-text {
  font-size: $font-size-sm;
  color: $text-secondary;
  line-height: 1.8;
}

.examples {
  display: flex;
  flex-direction: column;
  gap: 8rpx;
  margin-top: 8rpx;
  padding: 12rpx;
  background: $card-bg;
  border-radius: $border-radius-small;
}

.example-title {
  font-size: $font-size-xs;
  color: $text-secondary;
  font-weight: bold;
}

.example {
  padding-left: 16rpx;
}

.example-text {
  font-size: $font-size-xs;
  color: $text-primary;
  line-height: 1.6;
}

.suggestions {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.suggestion {
  font-size: $font-size-sm;
  color: $text-secondary;
  line-height: 1.8;
  padding: 12rpx;
  background: $bg-color;
  border-radius: $border-radius-small;
}

.actions {
  display: flex;
  gap: 16rpx;
}
</style>

