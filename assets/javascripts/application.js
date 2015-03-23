//= require modernizr.custom
//= require jquery
//= require remark
//= require deck/deck.core.js
//= require deck/extensions/deck.hash.js
//= require deck/extensions/deck.navigation.js
//= require deck/extensions/deck.status.js
//= require syntax-highlighter/XRegExp.js
//= require syntax-highlighter/shCore.js
//= require syntax-highlighter/shBrushPlain.js
//= require syntax-highlighter/shBrushXml.js
//= require syntax-highlighter/shBrushRuby.js
//= require syntax-highlighter/shBrushBash.js
//= require syntax-highlighter/shBrushJScript.js
//= require syntax-highlighter/shBrushCss.js
//= require syntax-highlighter/shBrushSass.js
//= require_self

$(function() {  
  // Init deck
  $.deck('.slide');
  
  // SyntaxHighlighter init
  SyntaxHighlighter.all();
});