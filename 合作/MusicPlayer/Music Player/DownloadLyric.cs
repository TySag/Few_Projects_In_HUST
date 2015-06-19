using System;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Net;

namespace MusicPlayer
{
    class DownloadLyric
    {
        string urlSongInfor = "http://box.zhangmen.baidu.com/x?op=12&count=1&title={0}$${1}$$$$";//获取歌曲信息的地址
        string urlGeCi = "http://box.zhangmen.baidu.com/bdlrc/";//下载歌词的不完全地址
        
        /// <summary>
        /// 获取歌词
        /// <param name="songName">歌曲名称</param>
        /// <param name="singerName">演唱人</param>
        /// </summary>
        public string GetLyric(string songName, string singerName)
        {
            urlSongInfor = String.Format(urlSongInfor, songName, singerName);//url地址
            string content = getWebContent(urlSongInfor);//获取歌曲信息
            string matchCount = @"<count>(?<count>\d+)</count>";//匹配找到歌词个数的正则表达式
            string matchLrcid = @"<lrcid>(?<id>\d+)</lrcid>";//匹配歌词加密文件名的正则表达式
            int songCount = 0;//找到歌词个数
            int lrcid = 0;//歌词加密文件名
            Regex regex = new Regex(matchCount);
            Match songInfo = regex.Match(content);
            songCount = Convert.ToInt32(songInfo.Groups["count"].Value);
            if (songCount == 0)
            {
                return "没有找到歌词";//搜索到的歌词数为0
            }
            regex = new Regex(matchLrcid);
            MatchCollection matchResult = regex.Matches(content);
            foreach (Match temp in matchResult)
            {
                lrcid = Convert.ToInt32(temp.Groups["id"].ToString());
                break;
            }
            int fileID = lrcid / 100;//计算出加密后的歌词文件名
            urlGeCi += fileID + "/" + lrcid + ".lrc";
            return getWebContent(urlGeCi);
        }

        /// <summary>
        /// 获取远程网页内容
        /// </summary>
        /// <param name="url">url地址</param>
        /// <returns></returns>
        private string getWebContent(string url)
        {
            try
            {
                StringBuilder sb = new StringBuilder("");
                WebRequest request = WebRequest.Create(url);
                request.Timeout = 10000;//10秒请求超时
                StreamReader sr = new StreamReader(request.GetResponse().GetResponseStream(), Encoding.GetEncoding("GB2312"));
                while (sr.Peek() >= 0)
                {
                    sb.Append(sr.ReadLine());
                }
                return sb.ToString();
            }
            catch (WebException ex)
            {
                return ex.Message;
            }
        }
    }
}
