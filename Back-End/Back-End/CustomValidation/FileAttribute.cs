using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Reflection;
using System.Web;
using System.IO;

namespace Back_End.CustomValidation
{
    public class FileAttribute:ValidationAttribute
    {
        public override bool IsValid(object value)
        {
            if (value != null)
            {
                HttpPostedFileWrapper file = (HttpPostedFileWrapper)value;
                String attributo = Path.GetExtension(file.FileName);
                if (attributo == ".xlsx") return true;
            }
            return false;
        }
    }
}