defmodule CS.Complains.Locale do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @required ~w[country]a
  @optional ~w[state city]a

  @primary_key false
  schema "locales" do
    field(:country, :string)
    field(:state, :string, default: "")
    field(:city, :string, default: "")
  end

  @spec changeset(%__MODULE__{}, any) :: Ecto.Changeset.t()
  def changeset(locale, attrs) do
    locale
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> custom_validations()
  end

  @spec search_changeset(%__MODULE__{}, any) :: Ecto.Changeset.t()
  def search_changeset(company, attrs) do
    company
    |> cast(attrs, @required ++ @optional)
  end

  @country ~w[
    Afghanistan
    Åland-Islands
    Albania
    Algeria
    American-Samoa
    Andorra
    Angola
    Anguilla
    Antarctica
    Antigua
    Barbuda
    Argentina
    Armenia
    Aruba
    Australia
    Austria
    Azerbaijan
    Bahamas
    Bahrain
    Bangladesh
    Barbados
    Belarus
    Belgium
    Belize
    Benin
    Bermuda
    Bhutan
    Bolivia
    Bonaire
    Bosnia
    Herzegovina
    Botswana
    Bouvet-Island
    Brazil
    British-Indian-Ocean-Territory
    Brunei-Darussalam
    Bulgaria
    Burkina-Faso
    Burundi
    Cambodia
    Cameroon
    Canada
    Cape-Verde
    Cayman-Islands
    Central-African-Republic
    Chad
    Chile
    China
    Christmas-Island
    Cocos-(Keeling)-Islands
    Colombia
    Comoros
    Congo
    Cook-Islands
    Costa-Rica
    Côte-d'Ivoire
    Croatia
    Cuba
    Curaçao
    Cyprus
    Czech-Republic
    Denmark
    Djibouti
    Dominica
    Dominican-Republic
    Ecuador
    Egypt
    El-Salvador
    Equatorial-Guinea
    Eritrea
    Estonia
    Ethiopia
    Falkland-Islands-(Malvinas)
    Faroe-Islands
    Fiji
    Finland
    France
    French-Guiana
    French-Polynesia
    French-Southern-Territories
    Gabon
    Gambia
    Georgia
    Germany
    Ghana
    Gibraltar
    Greece
    Greenland
    Grenada
    Guadeloupe
    Guam
    Guatemala
    Guernsey
    Guinea
    Guinea-Bissau
    Guyana
    Haiti
    Heard-Island-and-McDonald-Islands
    Holy-See-(Vatican-City-State)
    Honduras
    Hong-Kong
    Hungary
    Iceland
    India
    Indonesia
    Iran
    Iraq
    Ireland
    Isle-of-Man
    Israel
    Italy
    Jamaica
    Japan
    Jersey
    Jordan
    Kazakhstan
    Kenya
    Kiribati
    Korea
    Kuwait
    Kyrgyzstan
    Lao-People's-Democratic-Republic
    Latvia
    Lebanon
    Lesotho
    Liberia
    Libya
    Liechtenstein
    Lithuania
    Luxembourg
    Macao
    Macedonia
    Madagascar
    Malawi
    Malaysia
    Maldives
    Mali
    Malta
    Marshall-Islands
    Martinique
    Mauritania
    Mauritius
    Mayotte
    Mexico
    Micronesia
    Moldova
    Monaco
    Mongolia
    Montenegro
    Montserrat
    Morocco
    Mozambique
    Myanmar
    Namibia
    Nauru
    Nepal
    Netherlands
    New-Caledonia
    New-Zealand
    Nicaragua
    Niger
    Nigeria
    Niue
    Norfolk-Island
    Northern-Mariana-Islands
    Norway
    Oman
    Pakistan
    Palau
    Palestine
    Panama
    Papua-New-Guinea
    Paraguay
    Peru
    Philippines
    Pitcairn
    Poland
    Portugal
    Puerto-Rico
    Qatar
    Réunion
    Romania
    Russian-Federation
    Rwanda
    Saint-Barthélemy
    Saint-Helena
    Saint-Kitts-and-Nevis
    Saint-Lucia
    Saint-Martin-(French-part)
    Saint-Pierre-and-Miquelon
    Saint-Vincent
    Grenadines
    Samoa
    San-Marino
    Sao-Tome-and-Principe
    Saudi-Arabia
    Senegal
    Serbia
    Seychelles
    Sierra-Leone
    Singapore
    Sint-Maarten-(Dutch-part)
    Slovakia
    Slovenia
    Solomon-Islands
    Somalia
    South-Africa
    South-Georgia
    South-Sandwich-Islands
    South-Sudan
    Spain
    Sri-Lanka
    Sudan
    Suriname
    Svalbard
    Jan-Mayen
    Swaziland
    Sweden
    Switzerland
    Syrian-Arab-Republic
    Taiwan
    Tajikistan
    Tanzania
    Thailand
    Timor-Leste
    Togo
    Tokelau
    Tonga
    Trinidad-and-Tobago
    Tunisia
    Turkey
    Turkmenistan
    Turks-and-Caicos-Islands
    Tuvalu
    Uganda
    Ukraine
    United-Arab-Emirates
    United-Kingdom
    United-States
    United-States-Minor-Outlying-Islands
    Uruguay
    Uzbekistan
    Vanuatu
    Venezuela
    Viet-Nam
    Virgin-Islands,-British
    Virgin-Islands,-U.S.
    Wallis-and-Futuna
    Western-Sahara
    Yemen
    Zambia
    Zimbabwe
  ]

  @brazil_states ~w[
    AC
    AL
    AM
    AP
    BA
    CE
    DF
    ES
    GO
    MA
    MG
    MS
    MT
    PA
    PB
    PE
    PI
    PR
    RJ
    RN
    RO
    RR
    RS
    SC
    SE
    SP
    TO
    FN
    GB
    GU
    IG
    PP
    RB
  ]

  # TODO: add city validation based on state https://github.com/datasets-br/city-codes/blob/master/data/br-city-codes.csv
  # another mode of doing the validations is with this filds in a DB, but I dont know the efficience of that

  defp custom_validations(changeset) do
    changeset =
      changeset
      |> validate_inclusion(:country, @country)

    if changeset.changes[:country] == "Brazil" do
      changeset
      |> validate_inclusion(:state, @brazil_states)
    else
      changeset
    end
  end
end
