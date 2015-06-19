using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.Drawing.Imaging;

namespace MediaControlLibrary
{
    public class ImageProcess
    {
        /// <summary>
        /// 边框效果
        /// </summary>
        /// <param name="ig">源图片</param>
        /// <param name="border">边框长度</param>
        /// <returns>处理后的图片</returns>
        public static Bitmap BorderImage(Bitmap ig, int border)
        {
            if (ig == null)
                throw new ArgumentNullException("The image need to be drawed border can not be null");
            int width = ig.Width;
            int height = ig.Height;
            Rectangle rect = new Rectangle(0,0,width,height);
            Bitmap bmpBorder =(Bitmap)ig.Clone();
            if (border >= width / 2||border >=height/2)
                throw new ArgumentException("The border of twice length can not be over than the width or height");
            if (border <= 0)
                throw new ArgumentException("The border must be overthan 0");
            Color col = Color.FromArgb(0x6c, 0xa6, 0xcd);
            byte R = 0x6c, G = 0xa6, B = 0xcd;
            byte tmp =Math.Min((byte)((R + G + B) / (3 * border)),(byte)(B/3));
            using (Graphics g = Graphics.FromImage(bmpBorder))
            {
                using (Pen pen = new Pen(col,1))
                {
                    if (border == 1)
                    {
                        g.DrawRectangle(pen, rect);
                    }
                    else
                    {
                        for (int i = 1; i <=border; i++)
                        {
                            g.DrawRectangle(pen, rect);
                            rect.Inflate(-1, -1);
                            int iR = Math.Min(R + i * tmp, 255);
                            int iG = Math.Min(G + i * tmp, 255);
                            int iB = Math.Min(B + i * tmp, 255);
                            pen.Color = Color.FromArgb(iR,iG,iB);
                        }
                    }
                }
            }
            return bmpBorder;
        }

        /// <summary>
        /// 图片灰白化
        /// </summary>
        /// <param name="bitmapSource">源图片</param>
        /// <returns>处理后的图片</returns>
        public static Bitmap Grayscale(Bitmap bitmapSource)
        {
            Bitmap bitmapGrayscale = null;
            if (bitmapSource != null && (bitmapSource.PixelFormat == PixelFormat.Format24bppRgb || bitmapSource.PixelFormat == PixelFormat.Format32bppArgb || bitmapSource.PixelFormat == PixelFormat.Format32bppRgb))
            {
                int width = bitmapSource.Width;
                int height = bitmapSource.Height;
                Rectangle rect = new Rectangle(0, 0, width, height);
                bitmapGrayscale = new Bitmap(width, height, PixelFormat.Format8bppIndexed);
                //设置调色板
                ColorPalette palette = bitmapGrayscale.Palette;
                for (int i = 0; i < palette.Entries.Length; i++)
                    palette.Entries[i] = Color.FromArgb(255, i, i, i);
                bitmapGrayscale.Palette = palette;
                BitmapData dataSource = bitmapSource.LockBits(rect, ImageLockMode.ReadOnly, bitmapSource.PixelFormat);
                BitmapData dataGrayscale = bitmapGrayscale.LockBits(rect, ImageLockMode.WriteOnly, PixelFormat.Format8bppIndexed);
                byte b, g, r;
                int strideSource = dataSource.Stride;
                int strideGrayscale = dataGrayscale.Stride;
                unsafe
                {
                    byte* ptrSource = (byte*)dataSource.Scan0.ToPointer();
                    byte* ptr1;
                    byte* ptrGrayscale = (byte*)dataGrayscale.Scan0.ToPointer();
                    byte* ptr2;
                    if (bitmapSource.PixelFormat == PixelFormat.Format24bppRgb)
                    {
                        for (int row = 0; row < height; row++)
                        {
                            ptr1 = ptrSource + strideSource * row;
                            ptr2 = ptrGrayscale + strideGrayscale * row;
                            for (int col = 0; col < width; col++)
                            {
                                b = *ptr1;
                                ptr1++;
                                g = *ptr1;
                                ptr1++;
                                r = *ptr1;
                                ptr1++;
                                *ptr2 = (byte)(0.114 * b + 0.587 * g + 0.299 * r);
                                ptr2++;
                            }
                        }
                    }
                    else    //bitmapSource.PixelFormat == PixelFormat.Format32bppArgb || bitmapSource.PixelFormat == PixelFormat.Format32bppRgb
                    {
                        for (int row = 0; row < height; row++)
                        {
                            ptr1 = ptrSource + strideGrayscale * row;
                            ptr2 = ptrGrayscale + strideGrayscale * row;
                            for (int col = 0; col < width; col++)
                            {
                                b = *ptr1;
                                ptr1++;
                                g = *ptr1;
                                ptr1++;
                                r = *ptr1;
                                ptr1 += 2;
                                *ptr2 = (byte)(0.114 * b + 0.587 * g + 0.299 * r);
                                ptr2++;
                            }
                        }
                    }
                }
                bitmapGrayscale.UnlockBits(dataGrayscale);
                bitmapSource.UnlockBits(dataSource);
            }
            return bitmapGrayscale;
        }

        public static Bitmap WhiteToGray(Bitmap bmpSource)
        {
            Bitmap bmp = (Bitmap)bmpSource.Clone();
            for (int x = 0, width = bmp.Width; x < width; x++)
            {
                for (int y = 0, height = bmp.Height; y < height; y++)
                {
                    Color color = bmp.GetPixel(x, y);
                    Color tmp;
                    if (color.A == 0)
                    {
                        tmp = Color.FromArgb(255, 150, 150, 150);
                    }
                    else
                    {
                        int g = (color.R + color.G + color.B) / 3-50;
                        tmp = Color.FromArgb(255, g, g, g);
                    }
                    bmp.SetPixel(x, y,tmp);
                }
            }
            return bmp;
        } 
    }
}
