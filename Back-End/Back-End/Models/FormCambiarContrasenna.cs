using System.ComponentModel.DataAnnotations;

namespace Back_End.Models
{
    public class FormCambiarContrasenna
    {
        [Required]
        public string Nombre { get; set; }
        
        [Required]
        public string Contrasenia { get; set; }

        [Required]
        public string NuevaContrasenia { get; set; }

    }
}