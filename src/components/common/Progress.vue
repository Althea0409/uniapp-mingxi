<template>
  <view class="progress-container">
    <view class="progress-bar" :style="{ height: height + 'rpx', borderRadius: borderRadius + 'rpx' }">
      <view 
        class="progress-fill" 
        :style="progressStyle"
      ></view>
    </view>
    <view v-if="showPercent" class="progress-text">{{ percent }}%</view>
  </view>
</template>

<script setup lang="ts">
import { computed } from 'vue';

interface Props {
  // 进度百分比 (0-100)
  percent: number;
  // 进度条高度
  height?: number;
  // 圆角
  borderRadius?: number;
  // 是否显示百分比文字
  showPercent?: boolean;
  // 进度条颜色类型
  colorType?: 'gradient' | 'primary' | 'success' | 'warning' | 'error';
  // 自定义颜色
  color?: string;
}

const props = withDefaults(defineProps<Props>(), {
  percent: 0,
  height: 12,
  borderRadius: 6,
  showPercent: false,
  colorType: 'gradient',
  color: '',
});

// 计算进度条样式
const progressStyle = computed(() => {
  const safePercent = Math.min(100, Math.max(0, props.percent));
  
  let background = '';
  if (props.color) {
    background = props.color;
  } else {
    switch (props.colorType) {
      case 'gradient':
        background = 'linear-gradient(90deg, #2B46FE, #7B61FF)';
        break;
      case 'primary':
        background = '#2B46FE';
        break;
      case 'success':
        background = '#52C41A';
        break;
      case 'warning':
        background = '#FAAD14';
        break;
      case 'error':
        background = '#F5222D';
        break;
      default:
        background = 'linear-gradient(90deg, #2B46FE, #7B61FF)';
    }
  }
  
  return {
    width: `${safePercent}%`,
    background,
    borderRadius: props.borderRadius + 'rpx',
  };
});
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.progress-container {
  display: flex;
  align-items: center;
  width: 100%;
}

.progress-bar {
  flex: 1;
  background-color: #E5E5E5;
  overflow: hidden;
  position: relative;
}

.progress-fill {
  height: 100%;
  transition: width 0.3s ease;
  position: relative;
}

.progress-text {
  margin-left: 16rpx;
  font-size: $font-size-sm;
  color: $text-secondary;
  min-width: 60rpx;
  text-align: right;
}
</style>

