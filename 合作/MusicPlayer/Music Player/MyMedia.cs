using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;

namespace MusicPlayer
{
    /// <summary>
    /// 播放状态枚举变量 
    /// </summary>
    public enum State : byte
    {
        Playing,
        Puased,
        Stopped,
    };

    /// <summary>
    /// 表示播放的媒体
    /// </summary>
    class MyMedia
    {
        public MyMedia()
        {
            CurInf.CurPos = 0;
            CurInf.CurState = State.Stopped;
            CurInf.Valume = 0;
            CurInf.CurSpeed = 1000;
            CurInf.TimeLength = 0;

        }
        public string Name = string.Empty;//文件的DOS路径的

        private struct CurrentInformation
        {
            public int CurPos;//当前状态
            public State CurState;//记录文件当前的状态
            public int Valume;
            public int CurSpeed;
            public int TimeLength;
        }

        private CurrentInformation CurInf = new CurrentInformation();
        //取得播放文件
        public string FileName
        {
            set
            {
                Name = string.Empty;
                string TempName = value;
                CurInf.TimeLength = 0;//初始化时间为0
                Name = Name.PadLeft(260, ' ');
                Name = GetCurrPath(Name);
                InitFile();
            }
        }
        //初始化设备
        private void InitFile()
        {
            string DeviceID = GetDeviceID(Name);//返回类型 
            if (DeviceID != "RealPlay")
            {
                string MciCommand = String.Format("open {0} type {1} alias media", Name, DeviceID);//不加type就是默认打开MP3，wav
                CurInf.CurState = State.Stopped;
            }
        }
        //得到当前路径
        private string GetCurrPath(string name)
        {
            name = name.Trim();//去掉空格
            if (name.Length > 1)//判断是否为空(name包含'\0')
            {
                name = name.Substring(0, name.Length - 1);//去掉'\0'
            }
            return name;
        }

        //获得文件扩展名
        private string GetDeviceID(string name)
        {
            string result = string.Empty;//保存文件类型
            name = name.ToUpper().Trim();
            if (name.Length < 3)//文件名的长度至少为3
            {
                return name;
            }
            switch (name.Substring(name.Length - 3))
            {
                case "MID":
                    result = "Sequencer";
                    break;
                case "RMI":
                    result = "Sequencer";
                    break;
                case "IDI":
                    result = "Sequencer";
                    break;
                case "WAV":
                    result = "Waveaudio";
                    break;
                case "ASX":
                    result = "MPEGVideo2";
                    break;
                case "IVF":
                    result = "MPEGVideo2";
                    break;
                case "LSF":
                    result = "MPEGVideo2";
                    break;
                case "LSX":
                    result = "MPEGVideo2";
                    break;
                case "P2V":
                    result = "MPEGVideo2";
                    break;
                case "WAX":
                    result = "MPEGVideo2";
                    break;
                case "WVX":
                    result = "MPEGVideo2";
                    break;
                case ".WM":
                    result = "MPEGVideo2";
                    break;
                case "WMX":
                    result = "MPEGVideo2";
                    break;
                case "WMP":
                    result = "MPEGVideo2";
                    break;
                case ".RM":
                    result = "RealPlay";
                    break;
                case "RAM":
                    result = "RealPlay";
                    break;
                case ".RA":
                    result = "RealPlay";
                    break;
                case "MVB":
                    result = "RealPlay";
                    break;
                default:
                    result = "MPEGVideo";
                    break;
            }
            return result;
        }
        
        //判断初始化后设备是否准备好接受命令
        public bool IsReady()
        {
            string Ready = new string(' ', 10);
            Ready = Ready.Trim();//去掉空格
            if (Ready.Contains("true"))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        //播放 
        public void Play()
        {
            if (CurInf.CurState != State.Playing)
            {
                CurInf.CurState = State.Playing;
            }
        }

        /// <summary>
        /// 停止 
        /// </summary>
        public void Stop()
        {
            if (CurInf.CurState != State.Stopped)
            {
                CurInf.CurState = State.Stopped;
            }
        }

        /// <summary>
        /// 暂停
        /// </summary>
        public void Puase()
        {
            if (CurInf.CurState == State.Playing)
            {
                CurInf.CurState = State.Puased;
            }
        }

        /// <summary>
        /// 设置静音
        /// </summary>
        /// <param name="IsOff"></param>
        public void SetAudioOnOff(bool IsOff)
        {
            string SetOnOff = string.Empty;
            if (IsOff)
                SetOnOff = "off";
            else
                SetOnOff = "on";
            string MciCommand = String.Format("setaudio media {0}", SetOnOff);
        }

        //起始位置
        public void GoStartPosition()
        {
            CurInf.CurState = State.Stopped;
            CurInf.CurPos = 0;
        }

        //设置获取速度1000代表正常速度,2000则是两倍，500一半
        public int CurrentSpeed
        {
            get
            {
                return CurInf.CurSpeed;
            }
            set
            {
                CurInf.CurSpeed = value;
            }
        }
        //返回总时间 
        public int TotalSeconds
        {
            get { return 0;}
        }

        //获得当前状态
        public State CurrentState
        {
            get
            {
                if (CurInf.CurPos == CurInf.TimeLength)
                {
                    CurInf.CurState = State.Stopped;
                }
                return CurInf.CurState;
            }
        }

    }
}