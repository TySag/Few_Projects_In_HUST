using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using System.Drawing;
using System.ComponentModel;

namespace PlaylistBox
{
    //TypeConverter未解决
    //[DefaultProperty("Text"),TypeConverter(typeof(ChatListItemConverter))]
    public class PlayList
    {
        private string text = "ListName";
        /// <summary>
        /// 获取或者设置列表项的显示文本
        /// </summary>
        //[DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public string Text
        {
            get { return text; }
            set
            {
                text = value;
                if (this.ownerPlayListBox != null)
                    this.ownerPlayListBox.Invalidate(this.bounds);
            }
        }

        private bool isOpen;
        /// <summary>
        /// 获取或者设置列表项是否展开
        /// </summary>
        [DefaultValue(false)]
        public bool IsOpen
        {
            get { return isOpen; }
            set
            {
                isOpen = value;
                if (this.ownerPlayListBox != null)
                    this.ownerPlayListBox.Invalidate();
            }
        }

        private Rectangle bounds;
        /// <summary>
        /// 获取列表项的显示区域
        /// </summary>
        [Browsable(false)]
        public Rectangle Bounds
        {
            get { return bounds; }
            internal set { bounds = value; }
        }

        private PlayListBox ownerPlayListBox;
        /// <summary>
        /// 获取列表项所在的控件
        /// </summary>
        [Browsable(false)]
        public PlayListBox OwnerPlayListBox
        {
            get { return ownerPlayListBox; }
            internal set { ownerPlayListBox = value; }
        }

        private ChatListSubItemCollection subItems;
        /// <summary>
        /// 获取当前列表项所有子项的集合
        /// </summary>
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        public ChatListSubItemCollection SubItems
        {
            get
            {
                if (subItems == null)
                    subItems = new ChatListSubItemCollection(this);
                return subItems;
            }
        }

        private Rectangle _menuBounds;
        /// <summary>
        /// 列表项菜单按钮的显示区域
        /// </summary>
        public Rectangle MenuBounds
        {
            get { return _menuBounds; }
            set { _menuBounds = value; }
        }

        /// <summary>
        /// 列表项的菜单按钮显示的图片
        /// </summary>
        public Image Menu
        {
            get
            {
                if (_isMouseOnMenu)
                {
                    return global::PlaylistBox.Properties.Resources.mediaitemsmenu_Light;
                }
                if (_isMouseDownMenu)
                {
                    return global::PlaylistBox.Properties.Resources.mediaitemsmenu_Dark;
                }
                return global::PlaylistBox.Properties.Resources.mediaitemsmenu_;
            }
        }

        private bool _isMouseOnMenu = false;
        public bool IsMouseOnMenu
        {
            get { return _isMouseOnMenu; }
            set { _isMouseOnMenu = value; }
        }

        private bool _isMouseDownMenu = false;
        public bool IsMouseDownMenu
        {
            get { return _isMouseDownMenu; }
            set { _isMouseDownMenu = value; }
        }

        public PlayList() { if (this.text == null) this.text = string.Empty; }
        public PlayList(string text) { this.text = text; }
        public PlayList(string text, bool bOpen)
        {
            this.text = text;
            this.isOpen = bOpen;
        }
        public PlayList(SongItem[] subItems)
        {
            this.subItems.AddRange(subItems);
        }
        public PlayList(string text, SongItem[] subItems)
        {
            this.text = text;
            this.subItems.AddRange(subItems);
        }
        public PlayList(string text, bool bOpen, SongItem[] subItems)
        {
            this.text = text;
            this.isOpen = bOpen;
            this.subItems.AddRange(subItems);
        }
        //自定义列表子项的集合 注释同 自定义列表项的集合
        public class ChatListSubItemCollection : IList, ICollection, IEnumerable
        {
            private int count;
            public int Count { get { return count; } }
            private SongItem[] m_arrSubItems;
            private PlayList owner;

            public ChatListSubItemCollection(PlayList owner) { this.owner = owner; }
            /// <summary>
            /// 对列表进行排序
            /// </summary>
            public void Sort()
            {
                Array.Sort<SongItem>(m_arrSubItems, 0, this.count, null);
                if (this.owner.ownerPlayListBox != null)
                    this.owner.ownerPlayListBox.Invalidate(this.owner.bounds);
            }

            //确认存储空间
            private void EnsureSpace(int elements)
            {
                if (m_arrSubItems == null)
                    m_arrSubItems = new SongItem[Math.Max(elements, 4)];
                else if (elements + this.count > m_arrSubItems.Length)
                {
                    SongItem[] arrTemp = new SongItem[Math.Max(m_arrSubItems.Length * 2, elements + this.count)];
                    m_arrSubItems.CopyTo(arrTemp, 0);
                    m_arrSubItems = arrTemp;
                }
            }

            /// <summary>
            /// 获取索引位置
            /// </summary>
            /// <param name="subItem">要获取索引的子项</param>
            /// <returns>索引</returns>
            public int IndexOf(SongItem subItem)
            {
                return Array.IndexOf<SongItem>(m_arrSubItems, subItem);
            }
            /// <summary>
            /// 添加一个子项
            /// </summary>
            /// <param name="subItem">要添加的子项</param>
            public void Add(SongItem subItem)
            {
                if (subItem == null)
                    throw new ArgumentNullException("SubItem cannot be null");
                this.EnsureSpace(1);
                if (-1 == IndexOf(subItem))
                {
                    subItem.OwnerListItem = owner;
                    m_arrSubItems[this.count++] = subItem;
                    if (this.owner.OwnerPlayListBox != null)
                        this.owner.OwnerPlayListBox.Invalidate();
                }
            }
            /// <summary>
            /// 添加一组子项
            /// </summary>
            /// <param name="subItems">要添加子项的数组</param>
            public void AddRange(SongItem[] subItems)
            {
                if (subItems == null)
                    throw new ArgumentNullException("SubItems cannot be null");
                this.EnsureSpace(subItems.Length);
                try
                {
                    foreach (SongItem subItem in subItems)
                    {
                        if (subItem == null)
                            throw new ArgumentNullException("SubItem cannot be null");
                        if (-1 == this.IndexOf(subItem))
                        {
                            subItem.OwnerListItem = this.owner;
                            m_arrSubItems[this.count++] = subItem;
                        }
                    }
                }
                finally
                {
                    if (this.owner.OwnerPlayListBox != null)
                        this.owner.OwnerPlayListBox.Invalidate();
                }
            }

            /// <summary>
            /// 移除一个子项
            /// </summary>
            /// <param name="subItem">要移除的子项</param>
            public void Remove(SongItem subItem)
            {
                int index = this.IndexOf(subItem);
                if (-1 != index)
                    this.RemoveAt(index);
            }

            /// <summary>
            /// 根据索引移除一个子项
            /// </summary>
            /// <param name="index">要移除子项的索引</param>
            public void RemoveAt(int index)
            {
                if (index < 0 || index >= this.count)
                    throw new IndexOutOfRangeException("Index was outside the bounds of the array");
                this.count--;
                for (int i = index, Len = this.count; i < Len; i++)
                    m_arrSubItems[i] = m_arrSubItems[i + 1];
                if (this.owner.OwnerPlayListBox != null)
                    this.owner.OwnerPlayListBox.Invalidate();
            }
            /// <summary>
            /// 清空所有子项
            /// </summary>
            public void Clear()
            {
                this.count = 0;
                m_arrSubItems = null;
                if (this.owner.OwnerPlayListBox != null)
                    this.owner.OwnerPlayListBox.Invalidate();
            }
            /// <summary>
            /// 根据索引插入一个子项
            /// </summary>
            /// <param name="index">索引位置</param>
            /// <param name="subItem">要插入的子项</param>
            public void Insert(int index, SongItem subItem)
            {
                if (index < 0 || index >= this.count)
                    throw new IndexOutOfRangeException("Index was outside the bounds of the array");
                if (subItem == null)
                    throw new ArgumentNullException("SubItem cannot be null");
                this.EnsureSpace(1);
                for (int i = this.count; i > index; i--)
                    m_arrSubItems[i] = m_arrSubItems[i - 1];
                subItem.OwnerListItem = this.owner;
                m_arrSubItems[index] = subItem;
                this.count++;
                if (this.owner.OwnerPlayListBox != null)
                    this.owner.OwnerPlayListBox.Invalidate();
            }
            /// <summary>
            /// 将集合类的子项拷贝至数组
            /// </summary>
            /// <param name="array">要拷贝的数组</param>
            /// <param name="index">拷贝的索引位置</param>
            public void CopyTo(Array array, int index)
            {
                if (array == null)
                    throw new ArgumentNullException("Array cannot be null");
                m_arrSubItems.CopyTo(array, index);
            }
            /// <summary>
            /// 判断子项是否在集合内
            /// </summary>
            /// <param name="subItem">要判断的子项</param>
            /// <returns>是否在集合内</returns>
            public bool Contains(SongItem subItem)
            {
                return this.IndexOf(subItem) != -1;
            }
            /// <summary>
            /// 根据索引获取一个列表子项
            /// </summary>
            /// <param name="index">索引位置</param>
            /// <returns>列表子项</returns>
            public SongItem this[int index]
            {
                get
                {
                    if (index < 0 || index >= this.count)
                        throw new IndexOutOfRangeException("Index was outside the bounds of the array");
                    return m_arrSubItems[index];
                }
                set
                {
                    if (index < 0 || index >= this.count)
                        throw new IndexOutOfRangeException("Index was outside the bounds of the array");
                    m_arrSubItems[index] = value;
                    if (this.owner.OwnerPlayListBox != null)
                        this.owner.OwnerPlayListBox.Invalidate(m_arrSubItems[index].Bounds);
                }
            }
            //接口实现
            int IList.Add(object value)
            {
                if (!(value is SongItem))
                    throw new ArgumentException("Value cannot convert to ListSubItem");
                this.Add((SongItem)value);
                return this.IndexOf((SongItem)value);
            }

            void IList.Clear()
            {
                this.Clear();
            }

            bool IList.Contains(object value)
            {
                if (!(value is SongItem))
                    throw new ArgumentException("Value cannot convert to ListSubItem");
                return this.Contains((SongItem)value);
            }

            int IList.IndexOf(object value)
            {
                if (!(value is SongItem))
                    throw new ArgumentException("Value cannot convert to ListSubItem");
                return this.IndexOf((SongItem)value);
            }

            void IList.Insert(int index, object value)
            {
                if (!(value is SongItem))
                    throw new ArgumentException("Value cannot convert to ListSubItem");
                this.Insert(index, (SongItem)value);
            }

            bool IList.IsFixedSize
            {
                get { return false; }
            }

            bool IList.IsReadOnly
            {
                get { return false; }
            }

            void IList.Remove(object value)
            {
                if (!(value is SongItem))
                    throw new ArgumentException("Value cannot convert to ListSubItem");
                this.Remove((SongItem)value);
            }

            void IList.RemoveAt(int index)
            {
                this.RemoveAt(index);
            }

            object IList.this[int index]
            {
                get
                {
                    return this[index];
                }
                set
                {
                    if (!(value is SongItem))
                        throw new ArgumentException("Value cannot convert to ListSubItem");
                    this[index] = (SongItem)value;
                }
            }

            void ICollection.CopyTo(Array array, int index)
            {
                this.CopyTo(array, index);
            }

            int ICollection.Count
            {
                get { return this.count; }
            }

            bool ICollection.IsSynchronized
            {
                get { return true; }
            }

            object ICollection.SyncRoot
            {
                get { return this; }
            }

            IEnumerator IEnumerable.GetEnumerator()
            {
                for (int i = 0, Len = this.count; i < Len; i++)
                    yield return m_arrSubItems[i];
            }
        }
    }
}
