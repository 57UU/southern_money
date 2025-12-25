// 默认本科生毕业论文的封面 (CS 格式)
#import "../fonts/font-def.typ": *
#import "data.typ": *

#let paper_cover(cover_logo_path: "../assets/scu_black.png", anonymous, title, school, author, id, mentor, date, grade, major) = {
  align(center)[
    // hust logo
    #v(40pt)

    // 匿名化处理需要去掉个人、机构信息
    #let logo_path = cover_logo_path


    #text(
      size: 26pt,
      font: songti,
      weight: "bold",
      tracking: 5pt,
    )[《数据库系统原理课程设计》]
    #v(20pt)

  

    #v(40pt)

    #let info_value(body,font:songti, bold: false,font_size: 15pt) = {
      rect(
        width: 100%,
        inset: 1pt,
        stroke: (
          bottom: 1pt + black,
        ),
        text(
          font: font,
          size: font_size,
          bottom-edge: "descender",
          weight:if bold {"bold"} else {"regular"},
        )[
          #body
        ]
      ) 
    }
    
    #let info_key(body,font:songti, bold: false,font_size: 15pt) = {
      text(
        font: font,
        size: font_size,
        weight: if bold {"bold"} else {"regular"},
      )[
        #body
      ]
    }

    #v(20pt)
    #let row(a,b, width_a: auto, width_b: auto) = grid(
      columns: (width_a, width_b),
      gutter: 6pt,
      a, b
    )

    #let titleSize=17pt
    #grid(
      
      columns: (370pt),
      rows: (25pt),
      gutter: 3pt,
      row(
        info_key("课题名称：",font: heiti, bold: true,font_size: titleSize),
        info_value(title,font: heiti, bold: true,font_size: titleSize)
      )
    )

    #v(20pt)




    #grid(
      columns: (340pt),
      rows: (30pt),
      gutter: 3pt,
      row(
        info_key("课题负责人名（学号）："), 
        info_value(u57u+[ ]+u57u_id)
      ),
      row(
        info_key("同组成员名单（角色）："),
        info_value(yyw+[ ]+yyw_id)
      ),
      info_value(lpj+[ ]+lpj_id),
      info_value(hr+[ ]+hr_id),
      v(20pt),
      row(
        info_key("指导教师："),
        info_value("郭际香")
      ),
      row(
        info_key("评阅成绩：", bold: true),
        info_value("")
      ),
      row(
        info_key("评阅意见："),
        info_value("")
      ),
      info_value(""),
      info_value("")

    )
    #v(80pt)



    #text(
      font: songti,
      size: 16pt,
//      weight: "bold",
    )[
      提交报告时间 #date.at(0) 年 #date.at(1) 月 #date.at(2) 日
    ]
    #pagebreak()
  ]
}