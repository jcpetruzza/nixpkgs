{ stdenv, rustPlatform, fetchFromGitHub, coreutils, libiconv, Security, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "0.13.5b";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gcv9w79r9q3rzrdqiq9xgh68ya653sq84vzgf0fb154zmzjkxfv";
  };

  cargoSha256 = "0534jykfnqs1gfnmijkpcf91ddpbggw7p25h4arci14lgd2wrmgd";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  postPatch = ''
    substituteInPlace src/verb_store.rs --replace '"/bin/' '"${coreutils}/bin/'
  '';

  postInstall = ''
    # install shell completion files
    OUT_DIR=target/release/build/broot-*/out

    installShellCompletion --bash $OUT_DIR/{br,broot}.bash
    installShellCompletion --fish $OUT_DIR/{br,broot}.fish
    installShellCompletion --zsh $OUT_DIR/{_br,_broot}
  '';

  meta = with stdenv.lib; {
    description = "An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    maintainers = with maintainers; [ magnetophon ];
    license = with licenses; [ mit ];
    platforms = platforms.all;
  };
}
