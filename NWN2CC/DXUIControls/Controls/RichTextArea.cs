using System.Drawing;
using AvengersUTD.Odyssey.UserInterface.Style;
using Microsoft.DirectX;
using Font = Microsoft.DirectX.Direct3D.Font;
using System.Collections.Generic;

namespace AvengersUTD.Odyssey.UserInterface.RenderableControls
{
    public class RichTextArea : Panel
    {
        const int DefaultLabelPaddingX = 4;
        const int DefaultLabelPaddingY = 4;
        string textMarkup;
        int rowCount;
        LabelPage page;

        // Default text style, ie the font to use when no markup info is specified.
        TextStyle textStyle;

        public Font Font
        {
            get { return page.Font; }
            set { page.Font = value; }
        }

        public TextStyle Style { get { return textStyle; } }

        public RichTextArea(string id, Vector2 position, Size size, string text, TextStyle style) :
            this(id, position, size, text, style, BorderStyle.None, ColorArray.Transparent)
        {
            shape = Shape.None;
        }


        public RichTextArea(string id, Vector2 position, Size size, string text, TextStyle style,
                            BorderStyle borderStyle, ColorArray colorArray)
            : base(id, position, size, Shape.Rectangle, borderStyle,
                   Shapes.ShadeTopToBottom, colorArray)
        {
            Vector2 labelPosition = new Vector2(DefaultLabelPaddingX, DefaultLabelPaddingY);
            textMarkup = text;
            textStyle = style;
            
            LabelFormatter lF = new LabelFormatter(id, textStyle, labelPosition,
                                                   new Size(size.Width - 2 * DefaultLabelPaddingX,
                                                            size.Height - DefaultLabelPaddingY), textMarkup);
            page = lF.FormattedLabelCollection;

            foreach (Label l in page.LabelCollection)
            {
                if (l != null)
                    Add(l);
            }

            page.Align();
        }

        public List<string> Text
        {
            set
            {
                int i = 0;
                foreach (Label l in page.LabelCollection)
                {
                    if (i < value.Count)                    
                        l.Text = value[i];                                            
                    else
                        l.Text = "";
                    i++;
                }
            }
        }
    }
}