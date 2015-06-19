using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.ComponentModel;
using System.Runtime.InteropServices;
using System.Drawing.Imaging;

namespace PlaylistBox
{
    //有待解决
    //[TypeConverter(typeof(ExpandableObjectConverter))]
    public class SongItem : IComparable
    {
        private string songname;
        /// <summary>
        /// 歌曲名
        /// </summary>
        public string SongName
        {
            get { return songname; }
            set { songname = value; }
        }

        private int totaltime;
        /// <summary>
        /// 歌曲时长
        /// </summary>
        public int TotalTime
        {
            get { return totaltime; }
            set { totaltime = value; }
        }

        private Image headImage;
        /// <summary>
        /// 获取或者设置歌手头像
        /// </summary>
        public Image HeadImage
        {
            get { return headImage; }
            set { headImage = value; RedrawSongItem(); }
        }

        private Rectangle bounds;
        /// <summary>
        /// 获取列表子项显示区域
        /// </summary>
        [Browsable(false)]
        public Rectangle Bounds
        {
            get { return bounds; }
            internal set { bounds = value; }
        }

        private Rectangle headRect;
        /// <summary>
        /// 获取播放时头像显示区域
        /// </summary>
        [Browsable(false)]
        public Rectangle HeadRect
        {
            get { return headRect; }
            internal set { headRect = value; }
        }

        private Rectangle playButtonRect;
        /// <summary>
        /// 获取播放按钮显示区域
        /// </summary>
        [Browsable(false)]
        public Rectangle PlayButtonRect
        {
            get { return playButtonRect; }
            internal set { playButtonRect = value; }
        }

        private Rectangle deleteButtonRect;
        /// <summary>
        /// 获取删除按钮显示区域
        /// </summary>
        [Browsable(false)]
        public Rectangle DeleteButtonRect
        {
            get { return deleteButtonRect; }
            internal set { deleteButtonRect = value; }
        }

        private PlayList ownerList;
        /// <summary>
        /// 获取当前列表子项所在的列表项
        /// </summary>
        [Browsable(false)]
        public PlayList OwnerListItem
        {
            get { return ownerList; }
            internal set { ownerList = value; }
        }

        private void RedrawSongItem()
        {
            if (this.ownerList != null)
                if (this.ownerList.OwnerPlayListBox != null)
                    this.ownerList.OwnerPlayListBox.Invalidate(this.bounds);
        }

        /// <summary>
        /// 获取当前用户的黑白头像
        /// </summary>
        /// <returns>黑白头像</returns>
        public Bitmap GetDarkImage()
        {
            Bitmap b = new Bitmap(headImage);
            Bitmap bmp = b.Clone(new Rectangle(0, 0, headImage.Width, headImage.Height), PixelFormat.Format24bppRgb);
            b.Dispose();
            BitmapData bmpData = bmp.LockBits(new Rectangle(0, 0, bmp.Width, bmp.Height), ImageLockMode.ReadWrite, bmp.PixelFormat);
            byte[] byColorInfo = new byte[bmp.Height * bmpData.Stride];
            Marshal.Copy(bmpData.Scan0, byColorInfo, 0, byColorInfo.Length);
            for (int x = 0, xLen = bmp.Width; x < xLen; x++)
            {
                for (int y = 0, yLen = bmp.Height; y < yLen; y++)
                {
                    byColorInfo[y * bmpData.Stride + x * 3] =
                        byColorInfo[y * bmpData.Stride + x * 3 + 1] =
                        byColorInfo[y * bmpData.Stride + x * 3 + 2] =
                        GetAvg(
                        byColorInfo[y * bmpData.Stride + x * 3],
                        byColorInfo[y * bmpData.Stride + x * 3 + 1],
                        byColorInfo[y * bmpData.Stride + x * 3 + 2]);
                }
            }
            Marshal.Copy(byColorInfo, 0, bmpData.Scan0, byColorInfo.Length);
            bmp.UnlockBits(bmpData);
            return bmp;
        }

        private byte GetAvg(byte b, byte g, byte r)
        {
            return (byte)((r + g + b) / 3);
        }

        //实现排序接口
        int IComparable.CompareTo(object obj)
        {
            if (!(obj is SongItem))
                throw new NotImplementedException("obj is not ChatListSubItem");
            SongItem subItem = obj as SongItem;
            return (this.songname).CompareTo(subItem.songname);
        }

        public SongItem()
        {
            this.songname = string.Empty;
            this.totaltime = 0;
        }

        public SongItem(string _songName)
        {
            this.songname = _songName;
        }

        public SongItem(string _songName,int _totalTime)
        {
            this.songname = _songName;
            this.totaltime = _totalTime;
        }
    }
}
