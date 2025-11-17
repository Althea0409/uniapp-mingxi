<template>
  <view class="empty-container">
    <view class="empty-icon">
      <text class="icon-text">{{ icon }}</text>
    </view>
    <view class="empty-text">{{ text }}</view>
    <view v-if="description" class="empty-description">{{ description }}</view>
    <view v-if="showButton" class="empty-button">
      <Button 
        :text="buttonText" 
        type="primary" 
        size="small"
        @click="handleButtonClick"
      />
    </view>
    <slot></slot>
  </view>
</template>

<script setup lang="ts">
import Button from './Button.vue';

interface Props {
  // 图标（使用emoji或文字）
  icon?: string;
  // 提示文字
  text?: string;
  // 描述文字
  description?: string;
  // 是否显示按钮
  showButton?: boolean;
  // 按钮文字
  buttonText?: string;
}

const props = withDefaults(defineProps<Props>(), {
  icon: '📭',
  text: '暂无数据',
  description: '',
  showButton: false,
  buttonText: '返回首页',
});

const emit = defineEmits<{
  buttonClick: [];
}>();

// 处理按钮点击
const handleButtonClick = () => {
  emit('buttonClick');
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.empty-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80rpx 32rpx;
  text-align: center;
}

.empty-icon {
  margin-bottom: 32rpx;
  
  .icon-text {
    font-size: 120rpx;
    line-height: 1;
  }
}

.empty-text {
  font-size: $font-size-lg;
  color: $text-secondary;
  margin-bottom: 16rpx;
}

.empty-description {
  font-size: $font-size-sm;
  color: $text-placeholder;
  margin-bottom: 32rpx;
  line-height: 1.6;
}

.empty-button {
  margin-top: 16rpx;
}
</style>

