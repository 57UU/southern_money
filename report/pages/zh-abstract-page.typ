#import "../fonts/font-def.typ": *

// 中文摘要
#let zh_abstract_page(title, author, mentor, major, abstract, keywords: (), anonymous: false) = {
  show <_zh_abstract_>: {
    v(40pt)
    align(center)[
      #text(font: heiti, size: 18pt, title, weight: "bold")
    ]
    v(20pt)
  }

  [摘要 <_zh_abstract_>]


  set text(font: kaiti)

  align(center)[
    #text(size: 14pt, tracking: -1pt, font: songti)[
      // 根据匿名参数决定是否显示作者和导师信息
      
        #major #h(5pt) 专业
        #v(20pt)

        #text("作者",font: heiti) #h(5pt) #text(author,font: kaiti) #h(30pt) #text("指导老师",font: heiti) #h(5pt) #text(mentor,font: kaiti)
      

      #linebreak()
    ]
  ]

  text(size: 10.5pt, tracking: 0pt, font: songti)[
    #text(weight: "bold", [[摘要]    ],font: heiti)
    #abstract
  ]    
  
  linebreak()
  linebreak()


  
  text(size: 10.5pt, tracking: -1pt, font: songti)[
    #box(width: 2em)
    #text(weight: "bold", [关键词  ],font: heiti)
    #keywords.join("      ")
  ]    
}