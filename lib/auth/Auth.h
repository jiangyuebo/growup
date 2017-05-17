#ifndef AUTH_H
#define AUTH_H

#include <stdint.h>
#include <string.h>
#include <map>

using std::string;
namespace qcloud_cos {

class Auth {
public:

    /// @brief 返回cos_xml接口的签名
    ///        腾讯云签名文档：https://qcloud.com/document/product/436/7778
    /// @param app_id       项目的app_id
    /// @param secret_id    签名秘钥id，可在控制台获得
    /// @param secret_key   签名秘钥，可在控制台获得
    /// @param expired_time 签名文档中q_key_time，q_sign_time有效时间
    /// @param uri          签名秘钥id，可在控制台获得
    /// @param bucket_name  bucket名字，可在控制台获得
    /// @param op           HTTP操作GET、PUT
    /// @param user_params  用户参数
    /// @param user_headers http头部
    /// @return string 签名，可用于访问cos的xml接口
    static std::string AppSignXml(uint64_t app_id,
                        const std::string& secret_id,
                        const std::string& secret_key,
                        uint64_t expired_time,
                        const std::string& uri,
                        const std::string& bucket_name,
                        const std::string& op,
                        const std::map<string,string>& user_params,
                        const std::map<string,string>& user_headers);

private:
    // 禁止该类各种构造
    Auth() {}
    ~Auth() {}

    Auth(const Auth&);
    Auth& operator=(const Auth&);
};

} // namespace qcloud_cos

#endif // AUTH_H
