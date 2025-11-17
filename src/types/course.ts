// 课程相关类型定义
import type { CourseStatus, HomeworkStatus } from './common';

// 课程
export interface Course {
  id: string;
  name: string;
  teacher: string;
  department: string;
  cover: string;
  progress: number;
  chapter: string;
  nextClass: string;
  status: CourseStatus;
}

// 作业
export interface Homework {
  id: string;
  courseId: string;
  courseName: string;
  title: string;
  deadline: string;
  description: string;
  questionTypes: string;
  status: HomeworkStatus;
  score?: number;
  totalScore?: number;
  submitTime?: string;
  teacherComment?: string;
  timeSpent?: number;
}

// 预习任务
export interface Preview {
  id: string;
  courseId: string;
  courseName: string;
  title: string;
  duration: number;
  publishTime: string;
  content: string[];
  completed: boolean;
}

// 课表项
export interface ScheduleItem {
  id: string;
  courseId: string;
  courseName: string;
  teacher: string;
  location: string;
  startTime: string;
  endTime: string;
  weekday: number;
  week: number;
}

// 讨论
export interface Discussion {
  id: string;
  authorId: string;
  authorName: string;
  authorAvatar: string;
  group: string;
  title: string;
  content: string;
  images?: string[];
  replies: number;
  likes: number;
  heat: number;
  createTime: string;
}

// 资源推荐
export interface Resource {
  id: string;
  type: 'document' | 'video' | 'exercise';
  title: string;
  cover: string;
  description: string;
  matchRate: number;
  reason: string;
  duration?: number;
  rating?: number;
}

