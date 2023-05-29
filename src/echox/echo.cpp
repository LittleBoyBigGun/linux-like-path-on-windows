
#include <iostream>
#include "clipp.h"
#include <regex>

using namespace clipp; 

std::string enable_escape(std::string&& src);

int main(int argc, char* argv[]) {
    bool n = false, e = false ,E = true;
    bool is_help = false;
    std::vector<std::string> strs;

    auto cli = (
        option("--help").set(is_help).doc("display this help and exit"),
       
        option("-n").set(n).doc("do not output the trailing newline"),
        option("-e").set(e).doc("enable interpretation of backslash escapes")|
        option("-E").set(E).doc("disable interpretation of backslash escapes (default)"),
        
        opt_values("strings", strs)
        );

    auto parsed = parse(argc, argv, cli);
    if (!parsed) std::cout << make_man_page(cli, argv[0]);

    //todo:error handling

    if (e) E = false;

    if (e && is_help || E && is_help  || n && is_help) {
        std::cout << "bad option compose" << std::endl;
        return -1;
    }

        // --help
    if (is_help) {
        std::cout << make_man_page(cli, argv[0]);
    }
   
    //-E  
    if (E) {
        for (auto str : strs) {
            std::cout << str <<" ";
        }
        
        if (!n) {
            std::cout << std::endl;
        }
    }

    //-e
    if (e) {
        for (auto str : strs) {
            std::cout << enable_escape(std::move(str)) << " ";
        }
        if (!n) {
            std::cout << std::endl;
        }
    }
}

std::string enable_escape(std::string &&src) {
    /*
        \a	Bell(响铃)
        \b	Backspace(退格)
        \t	Horizontal Tab(水平制表符)
        \n	Line feed(换行键)
        \v	Vertical Tab(垂直制表符)
        \f	Form feed(换页键)
        \r	Carriage return(回车键)
    */

    //todo: -e -x -c
    
    std::string r;
    int len = src.size();
    int i   = 0;

    while (i < len) {
        char c = src.at(i);

        if (c == '\\' && i < len - 1) {
            char n = src.at(i+1);
            switch (n) {
            case 'a':
                r.push_back('\a');
                i = i + 2;
                break;
            case 'b':
                r.push_back('\b');
                i = i + 2;
                break;
            case 't':
                r.push_back('\t');
                i = i + 2;
                break;
            case 'n':
                r.push_back('\n');
                i = i + 2;
                break;
            case 'v':
                r.push_back('\v');
                i = i + 2;
                break;
            case 'f':
                r.push_back('\f');
                i = i + 2;
                break;
            case 'r':
                r.push_back('\r');
                i = i + 2;
                break;
            case '\\':
                r.push_back('\\');
                i = i + 2;
                break;
            default:
                i++;
                r.push_back(c);
            }

        }
        else {

            r.push_back(c);
            i++;
        }

    }
    r.push_back('\0');
    return r;
}
