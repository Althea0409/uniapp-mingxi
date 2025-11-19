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

// 作业题型
export type QuestionType = 'choice' | 'fill-blank' | 'essay';

// 基础题目
export interface Question {
  id: string;
  type: QuestionType;
  stem: string; // 题干
  score: number; // 分值
  explanation?: string; // 答案解析
}

// 选择题选项
export interface ChoiceOption {
  label: string; // e.g. 'A'
  text: string;
}

// 选择题
export interface ChoiceQuestion extends Question {
  type: 'choice';
  options: ChoiceOption[];
  answer: string; // 正确选项的 label
}

// 填空题
export interface FillBlankQuestion extends Question {
  type: 'fill-blank';
  answer: string[]; // 每个空的正确答案
}

// 问答题
export interface EssayQuestion extends Question {
  type: 'essay';
  answer: string; // 参考答案
}

export type AnyQuestion = ChoiceQuestion | FillBlankQuestion | EssayQuestion;

// 作业
export interface Homework {
  id:string;
  courseId: string;
  courseName: string;
  title: string;
  deadline: string;
  description: string;
  questionTypes: string;
  status: HomeworkStatus;
  questions?: AnyQuestion[]; // 详细题目列表
  score?: number;
  totalScore?: number;
  submitTime?: string;
  teacherComment?: string;
  timeSpent?: number;
  studentAnswers?: Record<string, any>; // 学生答案, key为题目id
  gradedDetails?: Record<string, { isCorrect: boolean; studentAnswer: any }>; // 批改详情
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

