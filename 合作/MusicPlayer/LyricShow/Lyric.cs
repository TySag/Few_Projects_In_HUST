using System;
using System.IO;
using System.Text;
using Microsoft.VisualBasic;

namespace LyricShow
{
    public class Lyric
    {
        public string[] LyricTimeLine; 
        public string[] LyricTextLine;
        public string path = "";
        public Lyric() { }

        public Lyric(string filename)
        {
            GetLyric(filename);
        }

        public void GetLyric(string FileName)
        {
            path = FileName;
            StreamReader sr = new StreamReader(FileName, Encoding.UTF8);
            string fs = sr.ReadToEnd(); 
            sr.Close();
            int pos = 1, l = 0, i1, i2; 
            bool hasdata = false;
            //歌词头部------------------------------------------------------------------------
            if (Microsoft.VisualBasic.Strings.InStr(pos, fs, "[ti:", CompareMethod.Text) != 0)
            {
                i1 = Microsoft.VisualBasic.Strings.InStr(pos, fs, "]", CompareMethod.Text) - 1;
                i2 = Microsoft.VisualBasic.Strings.InStr(pos, fs, "[ti:", CompareMethod.Text) + 3;
                l = i1 - i2;
                if (l <= 0) l = 1;
                pos += l + 5;
                hasdata = true;
            }

            if (Microsoft.VisualBasic.Strings.InStr(pos, fs, "[ar:", CompareMethod.Text) != 0)
            {
                i1 = Microsoft.VisualBasic.Strings.InStr(pos, fs, "]", CompareMethod.Text) - 1;
                i2 = Microsoft.VisualBasic.Strings.InStr(pos, fs, "[ar:", CompareMethod.Text) + 3;
                l = i1 - i2;
                if (l <= 0) l = 1;
                pos += l + 5;
                hasdata = true;
            }

            if (Microsoft.VisualBasic.Strings.InStr(pos, fs, "[al:", CompareMethod.Text) != 0)
            {
                i1 = Microsoft.VisualBasic.Strings.InStr(pos, fs, "]", CompareMethod.Text) - 1;
                i2 = Microsoft.VisualBasic.Strings.InStr(pos, fs, "[al:", CompareMethod.Text) + 3;
                l = i1 - i2;
                if (l <= 0) l = 1;
                pos += l + 5;
                hasdata = true;
            }

            if (Microsoft.VisualBasic.Strings.InStr(pos, fs, "[by:", CompareMethod.Text) != 0)
            {
                i1 = Microsoft.VisualBasic.Strings.InStr(pos, fs, "]", CompareMethod.Text) - 1;
                i2 = Microsoft.VisualBasic.Strings.InStr(pos, fs, "[by:", CompareMethod.Text) + 3;
                l = i1 - i2;
                if (l <= 0) l = 1;
                pos += l + 5;
                hasdata = true;
            }

            if (Microsoft.VisualBasic.Strings.InStr(fs, "[offset:", CompareMethod.Text) != 0)
            {
                i1 = Microsoft.VisualBasic.Strings.InStr(pos, fs, "]", CompareMethod.Text);
                i2 = Microsoft.VisualBasic.Strings.InStr(pos, fs, "[offset:", CompareMethod.Text) + 9;
                l = i1 - i2;
                if (l <= 0) l = 1;
                pos += l + 9;
                hasdata = true;
            }

            //歌词正文------------------------------------------------------------------------
            fs = Strings.Mid(fs, pos + (hasdata ? 1 : 0)).Trim();
            string[] lr;
            string[] times = new string[1000];
            string[] tstr = new string[1000];
            int timel, tstrl;
            timel = 0; tstrl = 0;
            lr = fs.Split('\r');
            for (int i = 0; i < lr.Length; i++)
            {
                string[] ts;
                ts = lr[i].Trim().Split(']');
                for (int j = 0; j < ts.Length; j++)
                {
                    if (Strings.Left(ts[j], 1) == "[")
                    {
                        times[timel] = Strings.Right(ts[j], 8);
                        timel += 1;
                    }
                    else
                    {
                        for (int n = tstrl; n < timel; n++)
                        {
                            tstr[n] = ts[j];
                        }
                        tstrl = timel;
                    }
                }
            }
            //进行排序
            int lnot = 0;
            for (int i = 0; i < 1000; i++)
            {
                if (times[i] == null)
                {
                    lnot = i;
                    break;
                }
            }
            for (int i = 0; i < lnot + 1; i++)
            {
                string t = times[i];
                times[i] = (Strings.Left(t, 2) + Strings.Mid(t, 4, 2) + Strings.Right(t, 2));
            }
            //开始排序
            for (int i = 0; i < lnot + 1; i++)
            {
                for (int j = 0; j < lnot - i + 1; j++)
                {
                    try
                    {
                        if (int.Parse(times[j]) > int.Parse(times[j + 1]))
                        {
                            string a, b;
                            a = times[j];
                            b = tstr[j];
                            times[j] = times[j + 1];
                            tstr[j] = tstr[j + 1];
                            times[j + 1] = a;
                            tstr[j + 1] = b;
                        }
                    }
                    catch
                    {
                        continue;
                    }
                }
            }
            //显示结果
            LyricTextLine = new string[lnot + 1];
            LyricTimeLine = new string[lnot + 1];
            for (int i = 0; i < lnot + 1; i++)
            {
                if (times[i] == "" || times[i] == null) { times[i] = "000000"; }
                LyricTextLine[i] = Strings.Trim(tstr[i]);
                LyricTimeLine[i] = Strings.Left(times[i], 2) + ":" + Strings.Mid(times[i], 3, 2) + ":" + Strings.Right(times[i], 2);
            }
            LyricTimeLine[LyricTimeLine.Length - 1] = "99:99.99";
        }
    }
}