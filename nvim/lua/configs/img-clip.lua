local img_clip = require "img-clip"

img_clip.setup {
  default = {
    dir_path = "fig",
  },

  filetypes = {
    tex = {
      template = [[
\begin{figure}[H]
  \centering
  \includegraphics[width=0.8\textwidth]{$FILE_PATH}
  \caption{$CURSOR}
  \label{fig:$LABEL}
\end{figure}
    ]],
    },
  },
}
