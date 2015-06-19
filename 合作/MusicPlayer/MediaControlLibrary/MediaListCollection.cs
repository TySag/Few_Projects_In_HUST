using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

namespace MediaControlLibrary
{
    public class MediaListCollection:IList,ICollection,IEnumerable
    {
        private MediaList[] lists;
        private MediaContainer ownerContainer;

        private int _count;
        /// <summary>
        /// 列表项的数目
        /// </summary>
        public int Count
        {
            get { return _count; }
        }

        public MediaListCollection(MediaContainer container)
        {
            this.ownerContainer = container;
        }

        /// <summary>
        /// 确认存储空间
        /// </summary>
        /// <param name="elements"></param>
        public void EnsureSpace(int elements)
        {
            if (lists == null)
                lists = new MediaList[Math.Max(4, elements)];
            else if (this._count + elements > lists.Length)
            {
                MediaList[] arr_temp = new MediaList[Math.Max(this._count + elements, lists.Length * 2)];
                lists.CopyTo(arr_temp,0);
                lists = arr_temp;
            }
        }

        /// <summary>
        /// 获取列表项索引位置
        /// </summary>
        /// <param name="list"></param>
        /// <returns></returns>
        public int IndexOf(MediaList list)
        {
            return Array.IndexOf<MediaList>(lists, list);
        }

        public void CloseAllList()
        {
            if(lists!=null)
                for (int i = 0; i < this._count; i++)
                {
                    lists[i].IsOpen = false;
                    this.ownerContainer.Invalidate();
                }
        }

        public void Add(MediaList list)
        {
            if (list == null)
                throw new ArgumentNullException("The list can not be null");
            this.EnsureSpace(1);
            if (-1 == IndexOf(list))
            {
                list.OwnerContainer = this.ownerContainer;
                lists[this._count++] = list;
                if (this.ownerContainer != null)
                    this.ownerContainer.Invalidate();
            }
        }

        public void AddRange(MediaList[] values)
        {
            if (values == null)
                throw new ArgumentNullException("The values can not be null");
            this.EnsureSpace(values.Length);
            try
            {
                foreach (MediaList list in values)
                {
                    if (list == null)
                        throw new ArgumentNullException("The list of the values can not be null");
                    if (-1 == IndexOf(list))
                    {
                        list.OwnerContainer = this.ownerContainer;
                        lists[this._count++] = list;
                    }
                }
            }
            finally
            {
                if (this.ownerContainer != null)
                    this.ownerContainer.Invalidate();
            }
        }

        public void Remove(MediaList list)
        {
            if (list == null)
                throw new ArgumentNullException("The list can not be null");
            RemoveAt(IndexOf(list));
        }

        public void RemoveAt(int index)
        {
            if (index < 0 || index > this._count)
                throw new ArgumentOutOfRangeException("The index has been out of the range");
            this._count--;
            for (int i = index, len = this._count; i < len; i++)
            {
                lists[i] = lists[i + 1];
            }
            if (this.ownerContainer != null)
                this.ownerContainer.Invalidate();
        }

        public void Clear()
        {
            this._count = 0;
            this.lists = null;
            if(this.ownerContainer!=null)
                this.ownerContainer.Invalidate();
        }

        public void Insert(int index, MediaList list)
        {
            if (index < 0 || index > this._count)
                throw new ArgumentOutOfRangeException("The index has been out of the range");
            if (list == null)
                throw new ArgumentNullException("The list can not be null");
            this.EnsureSpace(1);
            for (int i = this._count; i > index; i--)
            {
                lists[i] = lists[i - 1];
            }
            list.OwnerContainer = this.ownerContainer;
            lists[index] = list;
            ++this._count;
            this.ownerContainer.Invalidate();
        }

        public bool Contains(MediaList list)
        {
            return -1 != this.IndexOf(list);
        }

        public void CopyTo(Array array, int index)
        {
            if (array == null)
                throw new ArgumentNullException("The array can not be null");
            lists.CopyTo(array, index);
        }

        public MediaList this[int index]
        {
            get
            {
                if (index < 0 || index > this._count)
                    throw new ArgumentOutOfRangeException("The index has been out of the range");
                return lists[index];
            }
            set
            {
                if (index < 0 || index > this._count)
                    throw new ArgumentOutOfRangeException("The index has been out of the range");
                lists[index] = value;
                if (this.ownerContainer != null)
                    this.ownerContainer.Invalidate();
            }
        }

        #region 接口实现
        int IList.Add(object value)
        {
            if (!(value is MediaList))
                throw new ArgumentException("The value can not be converted to MediaList");
            this.Add((MediaList)value);
            return this.IndexOf((MediaList)value);
        }

        void IList.Clear()
        {
            this.Clear();
        }

        bool IList.Contains(object value)
        {
            if (!(value is MediaList))
                throw new ArgumentException("The value can not be converted to MediaList");
            return this.Contains((MediaList)value);
        }

        int IList.IndexOf(object value)
        {
            if (!(value is MediaList))
                throw new ArgumentException("The value can not be converted to MediaList");
            return this.IndexOf((MediaList)value);
        }

        void IList.Insert(int index, object value)
        {
            if (!(value is MediaList))
                throw new ArgumentException("The value can not be converted to MediaList");
            this.Insert(index, (MediaList)value);
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
            if (!(value is MediaList))
                throw new ArgumentException("The value can not be converted to MediaList");
            this.Remove((MediaList)value);
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
                if (!(value is MediaList))
                    throw new ArgumentException("The value can not be converted to MediaList");
                this[index] = (MediaList)value;
                if (this.ownerContainer != null)
                    this.ownerContainer.Invalidate(this[index].ClipBounds);
            }
        }

        void ICollection.CopyTo(Array array, int index)
        {
            this.CopyTo(array, index);
        }

        int ICollection.Count
        {
            get { return this._count; }
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
            for(int i=0,len=this._count;i<len;i++)
            yield return lists[i];
        }
        #endregion
    }
}
