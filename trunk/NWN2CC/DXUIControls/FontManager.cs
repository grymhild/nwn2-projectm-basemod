#region Using directives

using System;
using System.Collections.Generic;
using System.Drawing.Text;
using Microsoft.DirectX.Direct3D;
using System.Runtime.InteropServices;
using System.Reflection;
using System.IO;
using AvengersUTD.Odyssey.UserInterface.Helpers;
#endregion

namespace AvengersUTD.Odyssey.UserInterface
{
    public static class FontManager
    {
        public const string DefaultFontName = "Arial";

        static Dictionary<string, Font> fontCache = new Dictionary<string, Font>();
        static Font defaultFont = CreateFont(DefaultFontName, LabelSize.Normal, FontWeight.Normal, false);

        // future use;
        static PrivateFontCollection fontCollection = new PrivateFontCollection();

        #region Properties

        public static Font DefaultFont
        {
            get { return defaultFont; }
        }

        #endregion
        
        [DllImport("gdi32.dll")]
        private static extern IntPtr AddFontMemResourceEx(IntPtr pbFont, uint cbFont, IntPtr pdv, [In] ref uint pcFonts);

        /// <summary>
        /// Creates a user defined font object.
        /// </summary>
        /// <param name="fontName">The font name</param>
        /// <param name="size">Font size.</param>
        /// <param name="weight">Bold/Demi bold, etc.</param>
        /// <param name="isItalic">True if the text is too be rendered in italic.</param>
        /// <returns>The font object.</returns>
        /// 
        public static Font CreateFont(string fontName, int size, FontWeight weight, bool isItalic)
        {
            String fontKey = fontName + size + weight.ToString() + isItalic.ToString();
            return CreateFont(fontKey, fontName, size, weight, isItalic);
        }

        public static Font CreateFont(string ID, string fontName, int size, FontWeight weight, bool isItalic)
        {
            //String fontKey = fontName + size + weight.ToString() + isItalic.ToString();

            if (fontCache.ContainsKey(ID))
                return fontCache[ID];
            else
            {
                FontDescription fd = new FontDescription();
                Font font = new Font(
                    UI.Device,
                    size,
                    0,
                    weight,
                    1,
                    isItalic,
                    CharacterSet.Default,
                    Precision.Tt,
                    FontQuality.AntiAliased | FontQuality.ClearTypeNatural,
                    PitchAndFamily.FamilyRoman, fontName
                    );

                fontCache.Add(ID, font);
                return font;
            }
        }

        public static Font GetFont(string ID)
        {
            return fontCache[ID];
        }

        public static Font FontFromStream(string ID, Stream fontStream, float fontSize, System.Drawing.FontStyle fontStyle)
        {
            //create an unsafe memory block for the data
            System.IntPtr data = Marshal.AllocCoTaskMem((int)fontStream.Length);
            try
            {               
                //create a buffer to read in to
                Byte[] fontData = new Byte[fontStream.Length];
                //fetch the font program from the resource
                fontStream.Read(fontData, 0, (int)fontStream.Length);
                //copy the bytes to the unsafe memory block
                Marshal.Copy(fontData, 0, data, (int)fontStream.Length);

                // We HAVE to do this to register the font to the system (Weird .NET bug !)
                uint cFonts = 0;
                AddFontMemResourceEx(data, (uint)fontData.Length, IntPtr.Zero, ref cFonts);

                //pass the font to the font collection
                fontCollection.AddMemoryFont(data, (int)fontStream.Length);
            }
            catch (Exception ex)
            {
                throw new ApplicationException("Error! Cannot load font");
            }
            finally
            {
                //close the resource stream
                fontStream.Close();
                //free the unsafe memory
                Marshal.FreeCoTaskMem(data);
            }
            return GetPrivateFont(ID, fontSize, fontStyle);
        }

        private static Font GetPrivateFont(string ID, float fontSize, System.Drawing.FontStyle fontStyle)
        {
            System.Drawing.FontFamily[] fontFamilies = fontCollection.Families;
            if (fontFamilies[fontFamilies.Length - 1].IsStyleAvailable(fontStyle))
            {
                System.Drawing.Font newFont = new System.Drawing.Font(fontFamilies[0], fontSize, fontStyle, System.Drawing.GraphicsUnit.Pixel);
                Font d3font = new Font(UI.Device, newFont);
                //String fontKey = newFont.Name + fontSize + d3font.Description.Weight.ToString() + d3font.Description.IsItalic.ToString();
                fontCache.Add(ID, d3font);
                return d3font;
            }
            throw new ApplicationException("Error! Font does not support style " + System.Enum.GetName(typeof(System.Drawing.FontStyle), fontStyle));
        }

        public static Font FontFromTrueTypeFile(string ID, string filename, float fontSize, System.Drawing.FontStyle fontStyle)
        {
            try
            {                
                fontCollection.AddFontFile(filename);
                return GetPrivateFont(ID, fontSize, fontStyle);
            }
            catch
            {
                throw new ApplicationException("Error! Cannot load font: " + filename);
            }
        }

        /// <summary>
        /// Returns a font object from the default type.
        /// </summary>
        /// <param name="size">Font size.</param>
        /// <param name="weight">Bold/Demi bold, etc.</param>
        /// <param name="italic">True if the text is too be rendered in italic.</param>
        /// <returns>The font object.</returns>
        public static Font CreateFont(int size, FontWeight weight, bool italic)
        {
            return CreateFont(DefaultFontName, DefaultFontName, size, weight, italic);
        }

        /// <summary>
        /// Creates a font object from the default type specifying the size value to
        /// use. Use this overload if you don't want to set a font size value for each
        /// label created. Define those amounts by setting their properties in the 
        /// FontManager class before creating the labels.
        /// <remarks>For example, if you want to use a bigger screen resolution, you
        /// should increase the font size value stored in the [size]FontSize properties
        /// as needed and then using the related LabelSize enum value to create 
        /// the labels you need.</remarks>
        /// </summary>
        /// <param name="fontName">Name of the font family.</param>
        /// <param name="labelSize">Font size.</param>
        /// <param name="weight">Bold/Demi bold, etc.</param>
        /// <param name="italic">True if the text is too be rendered in italic.</param>
        /// <returns>The font object.</returns>
        public static Font CreateFont(LabelSize size, FontWeight weight, bool italic)
        {
            return CreateFont(DefaultFontName, size, weight, italic);
        }

        /// <summary>
        /// Creates a font object from the specified type specifying the size value to
        /// use. Use this overload if you don't want to set a font size value for each
        /// label created. Define those amounts by setting their properties in the 
        /// FontManager class before creating the labels.
        /// <remarks>For example, if you want to use a bigger screen resolution, you
        /// should increase the font size value stored in the [size]FontSize properties
        /// as needed and then using the related LabelSize enum value to create 
        /// the labels you need.</remarks>
        /// </summary>
        /// <param name="fontName">Name of the font family.</param>
        /// <param name="labelSize">Font size.</param>
        /// <param name="weight">Bold/Demi bold, etc.</param>
        /// <param name="italic">True if the text is too be rendered in italic.</param>
        /// <returns>The font object.</returns>
        public static Font CreateFont(string fontName, LabelSize labelSize, FontWeight weight, bool italic)
        {
            return CreateFont(StyleManager.GetLabelSize(labelSize), weight, italic);
        }
    }
}