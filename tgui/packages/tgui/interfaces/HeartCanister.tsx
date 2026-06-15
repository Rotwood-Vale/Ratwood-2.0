import {
  Box,
  LabeledList,
  NoticeBox,
  Section,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type AspectData = {
  name: string;
  desc: string;
  type: string;
  color: string;
  calibration_progress: number;
  calibration_required: number;
  // Trait-specific data
  liked_concepts?: string[];
  preferred_approaches_summary?: string;
  conflicting_traits?: string[];
  // Quirk-specific data
  conflicting_quirks?: string[];
  // Archetype-specific data
  possible_traits?: string[];
  possible_quirks?: string[];
  discharge_colors?: string[];
};

type Data = {
  filled: boolean;
  aspect_data?: AspectData;
};

export const HeartCanister = (props) => {
  const { data } = useBackend<Data>();
  const {
    filled = false,
    aspect_data,
  } = data || {};

  const {
    name = "无数据",
    desc = "暂无描述",
    type = "未知",
    color = "#ffffff",
    liked_concepts = [],
    preferred_approaches_summary = "无",
    conflicting_traits = [],
    conflicting_quirks = [],
    // Archetype-specific defaults
    possible_traits = [],
    possible_quirks = [],
    discharge_colors = [],
  } = aspect_data || {};

  return (
    <Window width={450} height={400} title="属性罐检查">
      <Window.Content>
        {/* 这里同步修改了判定，防止空罐时显示错误 */}
        {!filled && (type === "未知" || type === "Unknown") ? (
          <NoticeBox>这个罐子是空的。</NoticeBox>
        ) : (
          <>
            <Section title="属性概要">
              <LabeledList>
                <LabeledList.Item label="属性名称" color="yellow">
                  <Box color={color}>{name}</Box>
                </LabeledList.Item>
                <LabeledList.Item label="类型">
                  {type}
                </LabeledList.Item>
                <LabeledList.Item label="详细描述">
                  {desc}
                </LabeledList.Item>
              </LabeledList>
            </Section>

            {/* --- 人格原型详细信息 (修正了判定条件) --- */}
            {(type === "Archetype" || type === "原型") && (
              <Section title="原型详细信息">
                <LabeledList>
                  <LabeledList.Item label="潜在特性">
                    {possible_traits.length
                      ? possible_traits.join(', ')
                      : '无'}
                  </LabeledList.Item>
                  <LabeledList.Item label="潜在怪癖">
                    {possible_quirks.length
                      ? possible_quirks.join(', ')
                      : '无'}
                  </LabeledList.Item>
                  <LabeledList.Item label="分泌物颜色">
                    <Box>
                      {discharge_colors.length ? (
                        <Box>
                          {discharge_colors.map((dischargeColor, index) => (
                            <Box
                              key={index}
                              inline
                              style={{
                                width: '16px',
                                height: '16px',
                                backgroundColor: dischargeColor,
                                border: '1px solid #000',
                                margin: '2px',
                                display: 'inline-block',
                                verticalAlign: 'middle',
                              }}
                            />
                          ))}
                          <Box inline ml={1}>
                            ({discharge_colors.join(', ')})
                          </Box>
                        </Box>
                      ) : (
                        '无'
                      )}
                    </Box>
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            )}

            {/* --- 怪癖详细信息 (修正了判定条件) --- */}
            {(type === "Quirk" || type === "怪癖") && (
              <Section title="怪癖详细信息">
                <LabeledList>
                  <LabeledList.Item label="冲突怪癖">
                    {conflicting_quirks.length
                      ? conflicting_quirks.join(', ')
                      : '无'}
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            )}

            {/* --- 特性详细信息 (修正了判定条件) --- */}
            {(type === "Trait" || type === "特性") && (
              <Section title="特性详细信息">
                <LabeledList>
                  <LabeledList.Item label="冲突特性">
                    {conflicting_traits.length
                      ? conflicting_traits.join(', ')
                      : '无'}
                  </LabeledList.Item>
                  <LabeledList.Item label="喜好概念">
                    {liked_concepts.length
                      ? liked_concepts.join(', ')
                      : '无'}
                  </LabeledList.Item>
                  <LabeledList.Item label="偏好应对方案">
                    {preferred_approaches_summary}
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            )}
          </>
        )}
      </Window.Content>
    </Window>
  );
};
