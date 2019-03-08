program test;

uses SDL2, SDL2_image; //On Utilise SDL_image pour les images dans un autre format que le bmp

var
	Fenetre1: PSDL_Window;
    Renderer: PSDL_Renderer;
    Helico: PSDL_Texture;
    SurfaceRider: PSDL_Surface;
    TextureRider: PSDL_Texture;
    Recthelico: TSDL_Rect;
    Event: PSDL_Event;
    Rect2: TSDL_Rect;
    i: INTEGER;
    verif: BOOLEAN;

begin


// ===================== INTIALISATION ===================== //

	//On initialise le Système video

	if SDL_Init(SDL_INIT_VIDEO) < 0 then Halt;

	//On cree La fenetre et le renderer

	Fenetre1 := SDL_CreateWindow ('Fenetre1', 250, 250, 500, 500, SDL_WINDOW_SHOWN); //Création et affichage d'une fenêtre de 500x500 px à l'emplacement 250, 250 sur l'écran
	if Fenetre1 = nil then HALT;

	Renderer := SDL_CreateRenderer( Fenetre1, -1, 0 ); //Création du renderer associé à la fenetre "Fenetre1"
	if Renderer = nil then HALT;

    //On met le tileset dans la texture 'Helico'

  	Helico := IMG_LoadTexture( Renderer, 'helicopter.png' );
  	if Helico = nil then HALT;

	//On prepare les variables

	Recthelico.x := 0;
	Recthelico.y := 0;
	Recthelico.w := 128;
	Recthelico.h := 55;
	Rect2.w := 128;
	Rect2.h := 55;
	new( Event );
	verif := True;


// ===================== AFFICHAGE D'UN PNG, DEPLACEMENT D'UNE IMAGE A L'ECRAN, GESTION DES INPUTS ===================== //

	//On fait déplacer la zone que sélectionne le rectangle et on la colle au pointeur

	writeln('   Press ESC to Quit');
	While verif = true do //Tant que la boucle est vraie
	begin
		While SDL_PollEvent ( Event ) = 1 do //Tant que l'évènement attendu n'est pas réalisé
		begin
			Rect2.x := Event^.motion.x-(128 div 2); //On positionne le Rectangle D'affichage à la position de la souris
			Rect2.y := Event^.motion.y-(55 div 2);
		//	For i := 0 To 4 Do
		//	begin
				Recthelico.x := Recthelico.x+128; //La Zone sélectionnée de l'Hélico est déplacée de 128 px (La taille d'une frame sur le Tileset fourni)
				If (Recthelico.x > 384) Then //Si on dépasse la 4e frame
				begin
					Recthelico.x := 0; //On revient au début
				end;
				
				SDL_Delay (1); //Pendant 0.001 secondes ->

				//===================== AFFICHAGE D'UN BMP =====================//

				SurfaceRider := SDL_LoadBMP('rider.bmp'); //On met l'image dans une surface
				if SurfaceRider = nil then Halt;

				TextureRider := SDL_CreateTextureFromSurface (Renderer, SurfaceRider);
				if TextureRider = nil then Halt;

				if SDL_RenderCopy(Renderer, TextureRider, nil, nil) <> 0 then Halt;

				SDL_RenderCopy(Renderer, Helico, @Recthelico, @Rect2); //On met la Zone Sélectionnée dans le rectangle d'affichage

				//===================== DESSINER UNE PRIMITIVE =====================//

				SDL_SetRenderDrawColor ( Renderer, 255, 255, 0, 255);
				SDL_RenderDrawLine ( Renderer, 10, 10, 500, 500);
				SDL_RenderPresent(Renderer); //On Affiche le résultat ->
				SDL_SetRenderDrawColor ( Renderer, 0, 0, 0, SDL_ALPHA_OPAQUE);
				SDL_RenderClear(Renderer); //Puis on efface le résultat
			//end;
			If ( Event^.key.keysym.sym = SDLK_ESCAPE ) then verif := false; //Si on appuie sur Echap, la boucle passe a FALSE et donc on en sort
		end;
	end;

// ===================== FIN DU PROGRAMME ===================== //	

	//On nettoie la RAM
	dispose(Event);
	SDL_DestroyTexture( Helico );
	SDL_DestroyRenderer( Renderer );
	SDL_DestroyWindow ( Fenetre1 );

	//On quitte le programme

	SDL_Quit;

END.
