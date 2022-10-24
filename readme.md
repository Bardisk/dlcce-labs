 #  DLCCE Labshadows

这个仓库是作者修读南京大学本科课程《数字逻辑与计算机组成实验》时的项目文件夹。

缘起是 Vivado 自带的编辑器写代码实在是不太方便，于是作者便决定先自己在另一个文件夹写好代码，再用 iverilog + gtkwave 仿真之后再到 vivado 去综合。后来因为项目越来越大，还需要分模块编写，就用 makefile 实现了一些简单的项目管理功能。再后来发现 oj 有的时候也需要本地仿真调试，于是就顺便把 oj 拉了下来……

支持（或准备添加支持）的功能如下：

+ 按照模板自动新建一个 Lab 或 oj 项目。
+ 按照模板自动创建项目子模块（仅 Lab 项目）。
+ 自动导入和导出常用子模块。
+ 自动用 iverilog 仿真项目，或单独仿真子模块。
+ 用预编译命令导出项目单文件。
+ 自动打包实验报告及其附件。

仓库的使用环境应该是 VSCode  (with verilog-hdl support) + iverilog + gtkwave + svls 。Iverilog 的 linter 需要加上参数 `-I ../ -I include/`。

*声明：公开仓库仅是方便交流开发项目管理功能心得之用，请同修读这门课程的同学自觉遵守学术诚信，不要抄袭 `.sv` 源代码！*~~虽然没什么好抄的。~~

