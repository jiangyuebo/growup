#include "CodecUtil.h"
#include <cassert>
#include <fstream>
#include <iostream>
#include <string.h>
#include <string>
#include <sstream>
#include <algorithm>
#include <hmac.h>
#include <evp.h>
#include <sha.h>
#include <crypto.h>

using std::string;
namespace qcloud_cos {

std::string CodecUtil::HexToStr(const std::string& hex_str){
    char str[64];
    for(size_t i=0;i < hex_str.length(); i++){
        snprintf(str + i*2, 3, "%2.2x", hex_str[i]& 0xff);
    }
    return std::string(str);
}

std::string digestToString( unsigned char *digest){
    char letters[17] = "0123456789abcdef";
    std::stringstream ss;
    for ( int i=0; i<16; i++){
        unsigned char c = *(digest + i);
        ss << letters[ ( c >> 4 ) & 0xf ] << letters[ c & 0xf ];
    }
    return ss.str();
}

std::string CodecUtil::ToLower(const std::string& str){
    std::string data = str; 
    std::transform(data.begin(), data.end(), data.begin(), ::tolower);
    return data;
}

unsigned char CodecUtil::ToHex(const unsigned char &x) {
    return x > 9 ? (x - 10 + 'A') : x + '0';
}

string CodecUtil::UrlEncode(const string &str) {
    string encodedUrl = "";
    std::size_t length = str.length();
    for (size_t i = 0; i < length; ++i) {
        if (isalnum((unsigned char)str[i]) ||
            (str[i] == '-') ||
            (str[i] == '_') ||
            (str[i] == '.') ||
            (str[i] == '~') ||
            (str[i] == '/')) {

            encodedUrl += str[i];
        } else {
            encodedUrl += '%';
            encodedUrl += ToHex((unsigned char)str[i] >> 4);
            encodedUrl += ToHex((unsigned char)str[i] % 16);
        }
    }
    return encodedUrl;
}

std::string CodecUtil::UrlComponentEncode(const std::string& str)  
{  
    std::string strTemp = "";  
    size_t length = str.length();  
    for (size_t i = 0; i < length; i++)  
    {  
        if (isalnum((unsigned char)str[i]) ||   
            (str[i] == '-') ||  
            (str[i] == '_') ||   
            (str[i] == '.') ||   
            (str[i] == '~'))  
            strTemp += str[i];  
        else if (str[i] == ' ')  
            strTemp += "+";  
        else  
        {  
            strTemp += '%';  
            strTemp += ToHex((unsigned char)str[i] >> 4);  
            strTemp += ToHex((unsigned char)str[i] % 16);  
        }  
    }  
    return strTemp;  
}  

string CodecUtil::Base64Encode(const string &plainText) {
    static const char b64_table[65] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    const std::size_t plainTextLen = plainText.size();
    string retval((((plainTextLen + 2) / 3) * 4), '=');
    std::size_t outpos = 0;
    int bits_collected = 0;
    unsigned int accumulator = 0;
    const string::const_iterator plainTextEnd = plainText.end();

    for (string::const_iterator i = plainText.begin(); i != plainTextEnd; ++i) {
        accumulator = (accumulator << 8) | (*i & 0xffu);
        bits_collected += 8;
        while (bits_collected >= 6) {
            bits_collected -= 6;
            retval[outpos++] = b64_table[(accumulator >> bits_collected) & 0x3fu];
        }
    }

    if (bits_collected > 0) {
        assert(bits_collected < 6);
        accumulator <<= 6 - bits_collected;
        retval[outpos++] = b64_table[accumulator & 0x3fu];
    }
    assert(outpos >= (retval.size() - 2));
    assert(outpos <= retval.size());
    return retval;
}

string CodecUtil::HmacSha1(const string &plainText, const string &key) {
    const EVP_MD *engine = EVP_sha1();
    unsigned char *output = (unsigned char *)malloc(EVP_MAX_MD_SIZE);
    unsigned int output_len = 0;
    HMAC_CTX ctx;
    HMAC_CTX_init(&ctx);
    HMAC_Init_ex(&ctx, (char *)key.c_str(), key.length(), engine, NULL);
    HMAC_Update(&ctx, (unsigned char*)plainText.c_str(), plainText.length());
    HMAC_Final(&ctx, output, &output_len);
    HMAC_CTX_cleanup(&ctx);
    string hmac_sha1_ret((char *)output, output_len);
    free(output);
    return hmac_sha1_ret;
}

string CodecUtil::GetFileSha1(const string &localFilePath) {
    unsigned char buf[8192];
    SHA_CTX sc;
    SHA1_Init(&sc);
    size_t len;
    std::ifstream fileInput(localFilePath.c_str(), std::ios::in | std::ios::binary);
    while(!fileInput.eof()) {
        fileInput.read((char *)buf, sizeof(buf));
        len = fileInput.gcount();
        SHA1_Update(&sc, buf, len);
    }
    fileInput.close();

    unsigned char digestBuf[SHA_DIGEST_LENGTH];
    SHA1_Final(digestBuf, &sc);

    string digestStr = "";
    unsigned char temp_hex;
    for(int i = 0; i < SHA_DIGEST_LENGTH; ++i) {
        temp_hex = ToHex(digestBuf[i] / 16);
        digestStr.append(1, temp_hex);
        temp_hex = ToHex(digestBuf[i] % 16);
        digestStr.append(1, temp_hex);
    }

    std::transform(digestStr.begin(),digestStr.end(),digestStr.begin(),::tolower);
    return digestStr;
}

// string CodecUtil::GetFileMd5(const string &localFilePath) {
//     unsigned char buf[8192];
//     md5_state_t st;
//     md5_init(&st);
//     size_t len;
//     std::ifstream fileInput(localFilePath.c_str(), std::ios::in | std::ios::binary);
//     while(!fileInput.eof()) {
//         fileInput.read((char *)buf, sizeof(buf));
//         len = fileInput.gcount();
//         md5_append(&st, (const md5_byte_t *) buf, len);
//     }
//     fileInput.close();

//     unsigned char digest[16];
//     md5_finish(&st, digest);

//     return digestToString(digest);
// }

string CodecUtil::GetFileSha1(const char* buffer, size_t buff_len) {
    SHA_CTX sc;
    SHA1_Init(&sc);
    SHA1_Update(&sc, buffer, buff_len);

    unsigned char digestBuf[SHA_DIGEST_LENGTH];
    SHA1_Final(digestBuf, &sc);

    string digestStr;
    unsigned char temp_hex;
    for(int i = 0; i < SHA_DIGEST_LENGTH; ++i) {
        temp_hex = ToHex(digestBuf[i] / 16);
        digestStr.append(1, temp_hex);
        temp_hex = ToHex(digestBuf[i] % 16);
        digestStr.append(1, temp_hex);
    }

    std::transform(digestStr.begin(),digestStr.end(),digestStr.begin(),::tolower);
    return digestStr;
}

// string CodecUtil::GetFileMd5(const char* buffer, size_t buff_len) {
//     unsigned char digest[16];
//     md5_state_t st;
//     md5_init(&st);
//     md5_append(&st, (const md5_byte_t *) buffer, buff_len);
//     md5_finish(&st, digest);

//     return digestToString(digest);
// }

}
