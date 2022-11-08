
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Back_End.Models
{
    public class FormCrearSesionDAIR
    {
        [Required(ErrorMessage = "Insertar nombre válido")]
        public string Nombre { get; set; }
        [Required(ErrorMessage = "Insertar un periodo válido")]
        public int Periodo { get; set; }
        [Required(ErrorMessage = "Insertar fecha válida")]
        public string Fecha { get; set; }
        [Required(ErrorMessage = "Insertar hora inicial válida")]
        public string TiempoInicial { get; set; }
        [Required(ErrorMessage = "Insertar hora final válida")]
        public string TiempoFinal { get; set; }
        
    }
}