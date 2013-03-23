ods escapechar="~";


ods html file="jabberwocky.html";

ods text="~{style [font_style=italic] ~{include_file jabberwocky.txt}}";

ods text="~{style [font_style=italic]  ~{include_newlines True} ~{include_file jabberwocky.txt}}";

ods html close;

 
