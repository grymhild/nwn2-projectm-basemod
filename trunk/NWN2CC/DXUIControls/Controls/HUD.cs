#region Using directives

using System;
using System.Collections.Generic;
using System.Drawing;
using System.Text;
using AvengersUTD.Odyssey.UserInterface.Helpers;
using AvengersUTD.Odyssey.UserInterface.Style;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;

#endregion

namespace AvengersUTD.Odyssey.UserInterface.RenderableControls
{

    #region RenderInfo struct

    /// <summary>
    /// This struct is used by the HUD to know how many vertices
    /// and labels to render before stopping and rendering
    /// those vertices and labels who have to appear above
    /// the previous ones.
    /// </summary>
    internal struct RenderInfo
    {
        int vertexCount;
        int baseIndex;
        int baseVertex;
        int primitiveCount;
        int baseLabelIndex;
        int labelCount;

        #region Properties

        public int VertexCount
        {
            get { return vertexCount; }
        }

        public int BaseIndex
        {
            get { return baseIndex; }
        }

        public int BaseVertex
        {
            get { return baseVertex; }
        }

        public int PrimitiveCount
        {
            get { return primitiveCount; }
        }

        public int BaseLabelIndex
        {
            get { return baseLabelIndex; }
        }

        public int LabelCount
        {
            get { return labelCount; }
        }

        #endregion

        /// <summary>
        /// Creates a RenderInfo struct.
        /// </summary>
        /// <param name="baseIndex">The array index for the first index to use when rendering.</param>
        /// <param name="baseVertex">The array index for the first vertex to use when rendering.</param>
        /// <param name="vertexCount">How many vertices to render.</param>
        /// <param name="primitiveCount">How many primitives these vertices form.</param>
        /// <param name="baseLabelIndex">The array index for the first label to render.</param>
        /// <param name="labelCount">How many labels to render.</param>
        public RenderInfo(int baseIndex, int baseVertex, int vertexCount, int primitiveCount, int baseLabelIndex,
                          int labelCount)
        {
            this.baseIndex = baseIndex;
            this.baseVertex = baseVertex;
            this.vertexCount = vertexCount;
            this.primitiveCount = primitiveCount;
            this.baseLabelIndex = baseLabelIndex;
            this.labelCount = labelCount;
        }
    }

    #endregion

    public class HUD : ContainerControl, IDisposable
    {
        bool disposed;

        List<ISpriteControl> tempSpriteList, spriteList;
        List<RenderInfo> renderInfoList;

        bool designState = true;

        VertexBuffer vertexBuffer;
        IndexBuffer indexBuffer;

        Sprite sprite;

        // Currently focused control (receives keyboard inputs)
        BaseControl focusedControl;

        // The control that has currently captured the mouse (if any)
        // It receives all mouse input.
        BaseControl captureControl;

        // The control that has been entered by the mouse pointer
        BaseControl enteredControl;

        // Currently clicked control
        BaseControl clickedControl;

        WindowManager windowManager;

        #region Properties

        public Sprite SpriteManager
        {
            get { return sprite; }
        }

        public bool DesignState
        {
            get { return designState; }
            set { designState = value; }
        }

        /// <summary>
        /// Gets the currently FocusedControl.
        /// </summary>
        public BaseControl FocusedControl
        {
            get { return focusedControl; }
            internal set { focusedControl = value; }
        }

        /// <summary>
        /// Last control that the mouse pointer entered.
        /// </summary>
        internal BaseControl EnteredControl
        {
            get { return enteredControl; }
            set { enteredControl = value; }
        }

        /// <summary>
        /// Control that has captured the mouse pointer and
        /// receives all inputs whether or not the mouse pointer
        /// is inside its bounds.
        /// </summary>
        internal BaseControl CaptureControl
        {
            get { return captureControl; }
            set
            {
                if (value != null)
                    value.HasCaptured = true;
                else
                    captureControl.HasCaptured = false;
                captureControl = value;
            }
        }

        internal BaseControl ClickedControl
        {
            get { return clickedControl; }
            set { clickedControl = value; }
        }

        public WindowManager WindowManager
        {
            get { return windowManager; }
        }

        #endregion

        public HUD(string id, Size screenSize) :
            base(id, Vector2.Empty, screenSize, Shape.None, BorderStyle.None, Shapes.ShadeNone, ColorArray.Transparent)
        {
            spriteList = new List<ISpriteControl>();
            renderInfoList = new List<RenderInfo>();

            depth = new Depth(0, 0, 0, 0);

            sprite = new Sprite(UI.Device);
            focusedControl = enteredControl = this;
            isInside = true;
            windowManager = new WindowManager();
        }

        ShapeDescriptor PreCompute(ref List<ISpriteControl> newSprites)
        {
            List<ShapeDescriptor> shapeDescriptors = new List<ShapeDescriptor>();

            foreach (BaseControl ctl in PreOrderVisible)
            {
                if (ctl.IsVisible)
                {
                    if (ctl is ISpriteControl)
                        newSprites.Add(ctl as ISpriteControl);

                    if (ctl is IRenderableControl)
                    {
                        IRenderableControl rCtl = ctl as IRenderableControl;

                        if (rCtl.Shape == Shape.None)
                            continue;
                        else
                        {
                            rCtl.CreateShape();
                            shapeDescriptors.AddRange(rCtl.ShapeDescriptors);
                        }
                    }
                }
            }

            GenerateRenderSteps(shapeDescriptors, newSprites);

            //foreach (ShapeDescriptor shapeDescriptor in vertexDescriptors)
            //{
            //    shapeDescriptor.ArrayOffset = vIndex;
            //    vIndex += shapeDescriptor.Vertices.Length;
            //    numPrimitives += shapeDescriptor.NumPrimitives;
            //    sb.AppendLine(string.Format("{0}.{1}.{2}", shapeDescriptor.Depth.WindowLayer,
            //        shapeDescriptor.Depth.ComponentLayer, shapeDescriptor.Depth.ZOrder));
            //}

            return ShapeDescriptor.Join(shapeDescriptors.ToArray());
        }

        void DebugSprite(List<ISpriteControl> spriteList)
        {
            foreach (BaseControl ctl in spriteList)
                Console.WriteLine(ctl.ID + " - " + ctl.Depth);
        }

        void GenerateRenderSteps(List<ShapeDescriptor> shapeDescriptors, List<ISpriteControl> spriteList)
        {
            int windowLayers = 1, componentLayers = 1;
            int currentWindowLayer = 0, currentComponentLayer = 0;

            int vIndex = 0;
            int vCount = 0, iCount = 0, primitiveCount = 0;
            int vBase = 0, iBase = 0;
            int lIndex = 0, lBase = 0;

            Comparison<ISpriteControl> spriteComparison =
                delegate(ISpriteControl i1, ISpriteControl i2) { return ((i1 as BaseControl).Depth.CompareTo((i2 as BaseControl).Depth)); };

            Predicate<ISpriteControl> layerCheck = delegate(ISpriteControl iSpriteControl)
                                                       {
                                                           if ((iSpriteControl as BaseControl).Depth.ComponentLayer ==
                                                               currentComponentLayer)
                                                               return true;
                                                           else
                                                               return false;
                                                       };

            Predicate<ISpriteControl> windowCheck = delegate(ISpriteControl iSpriteControl)
                                                        {
                                                            if ((iSpriteControl as BaseControl).Depth.WindowLayer ==
                                                                currentWindowLayer)
                                                                return true;
                                                            else
                                                                return false;
                                                        };


            StringBuilder sb = new StringBuilder();

            renderInfoList.Clear();
            shapeDescriptors.Sort();
            spriteList.Sort(spriteComparison);


            foreach (ShapeDescriptor shapeDescriptor in shapeDescriptors)
            {
                // This code manages the windows layers, but the UI doesn't support
                // (yet) multiple windows so this will never execute

                if (shapeDescriptor.Depth.WindowLayer > currentWindowLayer)
                {
                    currentWindowLayer = shapeDescriptor.Depth.WindowLayer;
                    lBase = spriteList.FindIndex(lIndex, windowCheck);
                    //windowLayers++;

                    renderInfoList.Add(new RenderInfo(iBase, vBase, vCount, primitiveCount,
                                                      lIndex, lBase));

                    iBase += iCount;
                    vBase += vCount;
                    vCount = iCount = primitiveCount = 0;
                    lIndex = lBase;
                }
                if (shapeDescriptor.Depth.ComponentLayer > currentComponentLayer)
                {
                    currentComponentLayer = shapeDescriptor.Depth.ComponentLayer;
                    lBase = spriteList.FindIndex(lIndex, layerCheck);
                    //componentLayers++;

                    renderInfoList.Add(new RenderInfo(iBase, vBase, vCount, primitiveCount,
                                                      lIndex, lBase));
                    iBase += iCount;
                    vBase += vCount;
                    vCount = iCount = primitiveCount = 0;
                    lIndex = lBase;
                }

                shapeDescriptor.ArrayOffset = vIndex;
                iCount += shapeDescriptor.Indices.Length;
                vIndex += shapeDescriptor.Vertices.Length;
                vCount += shapeDescriptor.Vertices.Length;
                primitiveCount += shapeDescriptor.NumPrimitives;
            }

            renderInfoList.Add(new RenderInfo(iBase, vBase, vCount, primitiveCount, lBase, spriteList.Count));
        }

        int t = 0;

        public void BuildVertexBuffer()
        {
            t++;
            DebugManager.LogToScreen(string.Format("Times here: {0}", t));

            tempSpriteList = new List<ISpriteControl>();

            ShapeDescriptor final = PreCompute(ref tempSpriteList);

            if (final.Vertices.Length == 0)
                throw new ApplicationException("There are no vertices in the chosen HUD!");

            VertexBuffer tempVBuffer = new VertexBuffer(
                typeof (CustomVertex.TransformedColored),
                final.Vertices.Length,
                UI.Device,
                Usage.Dynamic | Usage.WriteOnly,
                CustomVertex.TransformedColored.Format,
                Pool.Default);

            IndexBuffer tempIBuffer = new IndexBuffer(
                typeof (int),
                final.Indices.Length,
                UI.Device,
                Usage.Dynamic | Usage.WriteOnly,
                Pool.Default);

            using (GraphicsStream vbStream = tempVBuffer.Lock(0, 0, LockFlags.Discard))
            {
                vbStream.Write(final.Vertices);
                tempVBuffer.Unlock();
            }

            using (GraphicsStream ibStream = tempIBuffer.Lock(0, 0, LockFlags.Discard))
            {
                ibStream.Write(final.Indices);
                tempIBuffer.Unlock();
            }

            if (vertexBuffer != null)
                vertexBuffer.Dispose();
            if (indexBuffer != null)
                indexBuffer.Dispose();

            vertexBuffer = tempVBuffer;
            indexBuffer = tempIBuffer;
            spriteList = tempSpriteList;

            OnLoad(this);
        }

        #region Exposed Events

        public event ControlEventHandler Load;

        protected virtual void OnLoad(BaseControl ctl)
        {
            if (Load != null)
                Load(ctl);
        }

        #endregion

        public void UpdateControl(ShapeDescriptor shapeDescriptor, BaseControl ctl)
        {
            if (disposed)
                return;

            if (vertexBuffer == null)
                return;

            if (shapeDescriptor == null)
                return;

            if (shapeDescriptor.ArrayOffset == 0)
            {
                //DebugManager.LogError("UpdateControl","Control with AOffset 0", ctl.ID);
            }
            GraphicsStream vbStream = vertexBuffer.Lock(
                CustomVertex.TransformedColored.StrideSize*shapeDescriptor.ArrayOffset,
                CustomVertex.TransformedColored.StrideSize*shapeDescriptor.Vertices.Length,
                LockFlags.None);

            if (shapeDescriptor.Vertices.Length == 0)
                DebugManager.LogToScreen("Updating an empty shapedescriptor!");

            vbStream.Write(shapeDescriptor.Vertices);
            vertexBuffer.Unlock();
        }

        public void Render()
        {
            Device device = UI.Device;
            device.RenderState.AlphaBlendOperation = BlendOperation.Add;
            device.RenderState.SourceBlend = Blend.SourceAlpha;
            device.RenderState.DestinationBlend = Blend.InvSourceAlpha;
            device.VertexFormat = CustomVertex.TransformedColored.Format;
            device.SetStreamSource(0, vertexBuffer, 0);

            device.Indices = indexBuffer;


            foreach (RenderInfo renderInfo in renderInfoList)
            {
                device.RenderState.AlphaBlendEnable = true;

                device.DrawIndexedPrimitives(PrimitiveType.TriangleList,
                                             0, renderInfo.BaseVertex, renderInfo.VertexCount, renderInfo.BaseIndex,
                                             renderInfo.PrimitiveCount);
                device.RenderState.AlphaBlendEnable = false;

                device.SetTexture(0, null);
                sprite.Begin(SpriteFlags.AlphaBlend);
                for (int i = renderInfo.BaseLabelIndex; i < renderInfo.LabelCount; i++)
                    spriteList[i].Render();
                sprite.End();
            }
        }

        public override bool IntersectTest(Point cursorLocation)
        {
            return Intersection.RectangleTest(position, size, cursorLocation);
        }


        public void BeginDesign()
        {
            designState = true;
        }

        public void EndDesign()
        {
            BuildVertexBuffer();
            internalControls.Sort();
            designState = false;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected void Dispose(bool disposing)
        {
            if (!disposed)
            {
                if (disposing)
                {
                    // dispose managed components
                    sprite.Dispose();
                    vertexBuffer.Dispose();
                    indexBuffer.Dispose();
                }

                // dispose unmanaged components
            }
            disposed = true;
        }


        ~HUD()
        {
            Dispose(false);
        }
    }
}