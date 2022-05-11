\version "2.22.1"

top = \relative { \aikenHeads d''8 c c b a4 a }
bottom = \relative { \aikenHeads a'8 f f4 g a }
% Beats 2, 3, and 4 revert note heads in the combine
{

\partCombine #'(2 . 9) \top \bottom
}
