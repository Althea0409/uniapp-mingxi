import { storage, StorageKeys } from '@/utils/storage';

export type ChatRole = 'system' | 'user' | 'assistant';
export interface ChatMessage { role: ChatRole; content: string }

export interface AIConfig {
  apiKey?: string;
  baseUrl?: string;
  model?: string;
}

export const getAIConfig = (): AIConfig => {
  return {
    apiKey: storage.get(StorageKeys.AI_API_KEY),
    baseUrl: storage.get(StorageKeys.AI_BASE_URL) || 'https://api.openai.com/v1',
    model: storage.get(StorageKeys.AI_MODEL) || 'gpt-4o-mini',
  };
};

export async function* streamChat(messages: ChatMessage[], cfg?: AIConfig): AsyncGenerator<string> {
  const config = { ...getAIConfig(), ...(cfg || {}) };
  if (!config.apiKey) {
    const q = messages[messages.length - 1]?.content || '';
    const mock = buildMockResponse(q);
    for (const token of chunkTextTokens(mock)) {
      yield token.text;
      await delay(token.delay);
    }
    return;
  }

  const url = `${config.baseUrl.replace(/\/$/, '')}/chat/completions`;
  const body = {
    model: config.model,
    messages,
    stream: true,
  };

  const res = await fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${config.apiKey}`,
    },
    body: JSON.stringify(body),
  });

  if (!res.body) {
    throw new Error('AI响应无数据');
  }

  const reader = res.body.getReader();
  const decoder = new TextDecoder('utf-8');
  let buffer = '';
  while (true) {
    const { value, done } = await reader.read();
    if (done) break;
    buffer += decoder.decode(value, { stream: true });
    const lines = buffer.split('\n');
    buffer = lines.pop() || '';
    for (const line of lines) {
      const trimmed = line.trim();
      if (!trimmed.startsWith('data:')) continue;
      const json = trimmed.substring(5).trim();
      if (json === '[DONE]') return;
      try {
        const obj = JSON.parse(json);
        const delta = obj?.choices?.[0]?.delta?.content || obj?.choices?.[0]?.message?.content || '';
        if (delta) {
          for (const token of chunkTextTokens(delta)) {
            yield token.text;
            await delay(token.delay);
          }
        }
      } catch {}
    }
  }
}

function delay(ms: number) { return new Promise(r => setTimeout(r, ms)); }
function* chunkTextTokens(text: string): Generator<{ text: string; delay: number }> {
  const baseMin = 20, baseMax = 40;
  const punctMin = 80, punctMax = 100;
  const breakMin = 100, breakMax = 120;
  for (let i = 0; i < text.length; i++) {
    const ch = text[i];
    let delay = rand(baseMin, baseMax);
    if (ch === '\n') {
      delay = rand(breakMin, breakMax);
    } else if (/[,.;:!?，。；：！？）】]/.test(ch)) {
      delay = rand(punctMin, punctMax);
    }
    yield { text: ch, delay };
  }
}
function rand(min: number, max: number) { return Math.floor(Math.random() * (max - min + 1)) + min; }

function buildMockResponse(q: string): string {
  const s = q.toLowerCase();
  if (/高数|数学|函数|极限|微积分/.test(q)) {
    return `关于高数学习：\n1）先掌握函数与极限的概念与常见等价代换\n2）配合例题，分步骤写出定义与判定条件\n3）建立错题本，按题型归纳方法\n4）每天进行10～20分钟计算训练\n5）遇到困难，用数形结合与极限直觉辅助理解`;
  }
  if (/概率|统计|样本|分布|期望|方差/.test(q)) {
    return `概率统计要点：\n1）理解样本/总体与随机变量的区别\n2）常见分布：二项、正态、泊松的适用场景\n3）会算期望与方差，掌握全概率与贝叶斯公式\n4）抽样估计与置信区间的意义\n5）做题时先判断独立性与事件划分`;
  }
  if (/线性代数|矩阵|向量|特征值|特征向量/.test(q)) {
    return `线代学习：\n1）熟悉矩阵运算与秩的概念\n2）线性相关/无关与基、维数\n3）特征值与特征向量的几何意义\n4）掌握相似对角化与正交化\n5）在应用题中明确变换的意义（旋转、缩放）`;
  }
  if (/背单词|记忆|词汇|英语/.test(q)) {
    return `背单词建议：\n1）分组记忆，控制在20～30词/天\n2）采用间隔重复法：1、2、4、7天复习\n3）建立词根词缀联想，配合例句使用\n4）听说读写结合：朗读与听写提升熟练度\n5）做小测，错误词汇加入重点复习清单`;
  }
  if (/阅读理解|语文|修辞|中心思想|段落/.test(q)) {
    return `阅读理解技巧：\n1）先看问题再读文，定位关键信息\n2）中心思想从标题/开头/结尾提炼\n3）修辞与表现手法结合文本例证\n4）答题结构：概括+依据句（引用短语）\n5）避免主观发挥，严格依据原文`;
  }
  if (/古诗文|文言文|翻译|实词|虚词|通假字/.test(q)) {
    return `文言文突破：\n1）积累常见实词义与虚词用法\n2）通读断句，标注主谓宾结构\n3）翻译遵循“直译为主、意译为辅”\n4）遇到通假字与古今异义要说明\n5）结合注释与上下文校验译文`;
  }
  if (/作文|写作|议论文|说明文/.test(q)) {
    return `写作提升：\n1）确定主题与受众，列出三点核心论据\n2）采用“提出问题-分析-解决”的结构\n3）段落开头给出中心句，结尾做小结\n4）使用连接词提升逻辑顺序\n5）完成后从“用词准确、句式多样、逻辑清晰”三点自检`;
  }
  if (/物理|电磁|力学|实验/.test(q)) {
    return `物理学习：\n1）先画图与受力分析，明确已知与未知\n2）选择合适模型：理想化、能量法或动量法\n3）单位与量纲检查，防止计算性错误\n4）实验部分注意误差来源与改进方法\n5）用公式推导+极端值检验提升直觉`;
  }
  if (/光学|透镜|成像|波动|干涉|衍射/.test(q)) {
    return `光学要点：\n1）会用成像公式与符号约定\n2）干涉/衍射问题先画几何关系\n3）区分相干条件与相位差来源\n4）实验题关注光路与误差\n5）用波长与几何量估算数量级`;
  }
  if (/化学|方程式|配平|氧化还原|酸碱|滴定/.test(q)) {
    return `化学学习：\n1）化学方程式配平优先守恒（原子/电荷）\n2）氧化还原判断电子得失与化学式价态\n3）酸碱滴定曲线与等当点概念\n4）溶液题重视浓度与体积换算\n5）实验安全与误差分析要完整`;
  }
  if (/生物|细胞|遗传|染色体|分裂|酶/.test(q)) {
    return `生物学习：\n1）图解流程（复制、转录、翻译、分裂）\n2）掌握孟德尔遗传模型与例外情况\n3）酶的特性：高效、专一、最适条件\n4）实验设计：变量、对照、重复\n5）用概念图整理关联`;
  }
  if (/历史|时间线|史料|近现代|事件|原因结果/.test(q)) {
    return `历史学习：\n1）按时间线建立事件串与因果链\n2）史料题区分立场与可靠性\n3）从政治/经济/文化三维分析影响\n4）对比中外同类事件找共性与差异\n5）用表格整理结论便于背诵`;
  }
  if (/地理|地图|气候|地形|经纬度|水文/.test(q)) {
    return `地理要点：\n1）读图时先定位经纬度与等高线\n2）气候判断看纬度、海陆位置与环流\n3）自然地理与人文地理联动分析\n4）计算题注意单位与比例尺\n5）区域题给出资源/交通/产业的综合评价`;
  }
  if (/政治|时政|观点|答题|价值观|制度/.test(q)) {
    return `政治答题：\n1）观点先表述，再用理论依据支撑\n2）结合材料给出现实意义与方法路径\n3）分点作答，每点有概念+结合材料\n4）避免空泛，突出逻辑因果\n5）结尾总结提升到价值层面`;
  }
  if (/编程|算法|调试|代码|python|c\+\+|java/.test(s)) {
    return `编程学习：\n1）先写伪代码与函数分解\n2）从输入/输出/边界用例出发测试\n3）调试时打印关键变量与中间结果\n4）算法题考虑时间/空间复杂度\n5）复盘时总结可复用的模板与陷阱`;
  }
  if (/作业|怎么写|提交|规范/.test(q)) {
    return `作业完成建议：\n1）先通读题目与要求，标注关键条件\n2）按题型分配时间，优先解决易得分项\n3）过程写清楚：公式、步骤、结论齐全\n4）提交前自查：是否有漏题与单位错误\n5）记录错题并在第二天复盘`;
  }
  if (/预习|复习|考试|计划|安排/.test(q)) {
    return `学习计划：\n1）目标拆分到周与日，明确可量化产出\n2）番茄钟25分钟专注+5分钟休息\n3）预习时做提纲，复习时做知识网\n4）每晚回顾并调整第二天安排\n5）每周进行一次综合测评，定位薄弱点`;
  }
  if (/这道题|怎么解|解题|步骤/.test(q)) {
    return `通用解题流程：\n1）提取已知与未知，建立符号表示\n2）画图或列式，选择合适的基本公式\n3）分步推导，必要时做边界与特殊值检查\n4）得到结论后检验维度与量级\n5）反思可否更简洁或通用化`;
  }
  if (/时间管理|注意力|效率|拖延|习惯/.test(q)) {
    return `效率提升：\n1）固定早晚例行清单与学习时段\n2）番茄钟+任务分块减少拖延\n3）手机消息分时查看，设定空白区\n4）每晚复盘：完成/未完成/改进\n5）每周一次总结并奖励自己`;
  }
  return `这是基于你的问题给出的学习建议：\n1）先梳理知识点清单\n2）配合例题进行针对练习\n3）总结错题并复盘`;
}