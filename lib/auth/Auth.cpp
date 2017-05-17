#include "Auth.h"
#include "CodecUtil.h"
#include <string.h>
#include <algorithm>
#include <cstdio>
#include <cstdlib>
#include <iostream>

using std::string;
namespace qcloud_cos {

// 腾讯云签名算法文档：https://qcloud.com/document/product/436/7778
std::string Auth::AppSignXml(uint64_t app_id,
                        const std::string& secret_id,
                        const std::string& secret_key,
                        uint64_t expired_time,
                        const std::string& uri,
                        const std::string& bucket_name,
                        const std::string& op,
                        const std::map<string,string>& _user_params,
                        const std::map<string,string>& _user_headers)
{

    // 将params和headers的key都转成小写（方便字典序排序）
    string key,value;
    std::map<string,string> user_params;
    for(std::map<string, string>::const_iterator it = _user_params.begin(); 
            it != _user_params.end(); ++it) {
        key = CodecUtil::ToLower(it->first);
        value = it->second;
        user_params[key] = value;
    }
    std::map<string,string> user_headers;
    for(std::map<string, string>::const_iterator it = _user_headers.begin(); 
            it != _user_headers.end(); ++it) {
        key = CodecUtil::ToLower(it->first);
        value = it->second;
        user_headers[key] = value;
    }

    // step 1: calc Signkey
    char q_key_time[30];                    //key有效时间
    uint64_t time_s = time((time_t*)NULL);  //time返回10位unix时间，单位s
    snprintf(q_key_time, 30, 
#if __WORDSIZE == 64
            "%lu;%lu", 
#else
            "%llu;%llu",
#endif
            time_s, time_s + expired_time);
    string sign_key = CodecUtil::HmacSha1(q_key_time, secret_key);
    string sign_key_str = CodecUtil::HexToStr(sign_key);
#ifdef SIGN_DEBUG
    std::cout<< "***********************************************" << std::endl;
    std::cout<< "**********q_key:" << q_key_time << std::endl;
    std::cout<< "**********sign_key_str:\n" << sign_key_str <<std::endl;
#endif

    // step 2: get FormatString
    string format_str;
    // operation
    format_str += CodecUtil::ToLower(op);
    format_str += "\n";
    // uri
    format_str += CodecUtil::UrlEncode(uri);
    format_str += "\n";
    // user_params
    string params_key, params_value, param_str;
    for(std::map<string, string>::const_iterator it = user_params.begin(); 
            it != user_params.end(); ) {
        params_key = it->first;
        params_value = it->second;
        param_str = CodecUtil::ToLower(CodecUtil::UrlComponentEncode(params_key)) 
            + "=" + CodecUtil::UrlComponentEncode(params_value);
        format_str += param_str;
        ++it;
        if(it != user_params.end())
            format_str += "&";
    }
    format_str += "\n";

    //user_headers
    string header_key, header_value, header_str;
    for(std::map<string, string>::const_iterator it = user_headers.begin(); 
            it != user_headers.end(); ) {
        header_key = it->first;
        header_value = it->second;
        header_str = CodecUtil::ToLower(CodecUtil::UrlComponentEncode(header_key)) 
            + "=" + CodecUtil::UrlComponentEncode(header_value);
        format_str += header_str;
        ++it;
        if(it != user_headers.end())
            format_str += "&";
    }
    format_str += "\n";
    string sha1_format_str = CodecUtil::GetFileSha1(format_str.c_str(),format_str.length());
#ifdef SIGN_DEBUG
    std::cout<< "**********format_str:\n" << format_str <<std::endl;
    std::cout<< "**********sha1_format_str:\n" << sha1_format_str <<std::endl;
#endif

    // step 3: get StringToSign
    char q_sign_time[30];   //sign有效时间（key有效时间一般大于或等于sign有效时间）
    strcpy(q_sign_time, q_key_time);
    string str2sign;
    str2sign += "sha1\n";
    str2sign += q_sign_time;
    str2sign += "\n";
    str2sign += sha1_format_str;
    str2sign += "\n";
#ifdef SIGN_DEBUG
    std::cout<< "**********str2sign:\n" << str2sign <<std::endl;
#endif
    // step 4: calc signature
    string signature = CodecUtil::HmacSha1(str2sign, sign_key_str);
    string signature_str = CodecUtil::HexToStr(signature);

    // step5: get Authorization
    string auth;
    auth += "q-sign-algorithm=sha1";
    auth += "&q-ak=";
    auth += secret_id;
    auth += "&q-sign-time=";
    auth += q_sign_time;
    auth += "&q-key-time=";
    auth += q_key_time;
    auth += "&q-header-list=";      //需要检查的header_key,字典序排列
    // auth += "host;range";
    for(std::map<string, string>::const_iterator it = user_headers.begin(); 
            it != user_headers.end(); ) {
        auth += CodecUtil::ToLower(it->first);
        ++it;
        if(it != user_headers.end())
            auth += ";";
    }
    auth += "&q-url-param-list=";   //需要检查的param_key,字典序排列
    for(std::map<string, string>::const_iterator it = user_params.begin(); 
            it != user_params.end(); ) {
        auth += CodecUtil::ToLower(it->first);
        ++it;
        if(it != user_params.end())
            auth += ";";
    }
    auth += "&q-signature=";
    auth += signature_str;
#ifdef SIGN_DEBUG
    std::cout<< "**********auth:\n" << auth <<std::endl<<std::endl;
    std::cout<< "***********************************************" << std::endl;
#endif

    return auth;
}

} // namespace qcloud_cos
