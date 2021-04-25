\version "2.20.0"

top = \relative { \aikenHeads d''8 c c b a4 a }
bottom = \relative { \aikenHeads a'8 f f4 g a }
% Beats 2, 3, and 4 revert note heads in the combine
{

\partcombine #'(2 . 9) \top \bottom
}

