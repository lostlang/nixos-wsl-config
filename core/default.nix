{
  modules,
  ...
}:
{
  imports = [
    ./default
    ./${modules}
  ];
}
